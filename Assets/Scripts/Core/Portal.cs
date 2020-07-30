using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Portal : MonoBehaviour
{
    [Header("Main Settings")]
    public Portal linkedPortal;
    public MeshRenderer screen;
    public int recursionLimit = 5;

    [Header("Advanced Settings")]
    public float nearClipOffset = 0.05f;
    public float nearClipLimit = 0.2f;

    // Private variables
    RenderTexture viewTexture;
    Camera portalCam;
    Camera playerCam;
    Material firstRecursionMat;
    [SerializeField] List<PortalTraveller> trackedTravellers;
    MeshFilter screenMeshFilter;
    LayerMask tempLayer;
    LayerMask playerLayer;
    LayerMask portalAlternatingLayerMask;

    //My portal parameter
    public List<PortalTraveller> portalTravellers;
    public GameObject PortalOut;
    public GameObject PortalIn;
    private GameObject player;
    private GameObject playerCamera;
    private Camera cam;
    public Transform bodyCam;
    private Transform bodyCamToTurnOff;
    private Quaternion portalDifference;
    private GameObject velocityMarker;
    private Vector3 velocityOut;
    private bool doCalculation = false;
    private static bool playerIsOverlapping = false;
    public RenderTexture tempRenderTexture;


    private GameObject placeholderTraveller;

    private Material tempPlayerSkybox;
    private Material tempPortalSkybox;

    public Material moonMat;
    public Material sunMat;
    public Material testMat;

    public Light DirectionalSunLight;
    public Light DirectionalMoonLight;

    private GameObject Level;
    private LayerMask StartLayerMask;

    [SerializeField] private bool teleportFrame = false;

    private Vector3 delayTeleportPosition;
    private bool isRendering = false;

    private Vector3 portalOldPos;
    private Vector3 oldPortalTransform;

    public GameObject Skeleton;

    void Awake()
    {
        playerCam = Camera.main;
        portalCam = GetComponentInChildren<Camera>();
        portalCam.enabled = false;
        trackedTravellers = new List<PortalTraveller>();
        screenMeshFilter = screen.GetComponent<MeshFilter>();
        screen.material.SetInt("displayMask", 1);

        tempPortalSkybox = portalCam.GetComponent<Skybox>().material;
        tempPlayerSkybox = playerCam.GetComponent<Skybox>().material;

        Level = GameObject.Find("Level");
        StartLayerMask = Level.layer;

        //Portal Awake Stuff
        //Find some game objects
        player = GameObject.FindWithTag("Player");
        playerCamera = GameObject.FindWithTag("MainCamera");
        cam = playerCamera.GetComponent<Camera>();
        PortalIn = transform.GetChild(2).GetChild(0).gameObject;

        //calculates the ridigbody velocity angle change
        float portalAngleDifference = Vector3.Angle(PortalIn.transform.forward, -PortalOut.transform.forward);
        portalDifference = Quaternion.AngleAxis(-portalAngleDifference, Vector3.Cross(PortalIn.transform.forward, -PortalOut.transform.forward));

        //Create velocity Marker
        velocityMarker = new GameObject("velocityMarker");
        
    }


    void LateUpdate()
    {
        //if (trackedTravellers.Count == 0)
        //{
        //    trackedTravellers.Add(player.GetComponent<PortalTraveller>());
        //    player.GetComponent<PortalTraveller>().EnterPortalThreshold();
        //}

        HandleTravellers();
        Debug.DrawLine(bodyCam.position, bodyCam.position + 5 * bodyCam.forward, Color.blue);
        Debug.DrawLine(player.transform.position, player.transform.position + 5 * player.transform.forward, Color.red);


        //Teleport velocity
        velocityMarker.transform.SetParent(PortalIn.transform);
        velocityMarker.transform.position = PortalIn.transform.position + player.GetComponent<Rigidbody>().velocity;
        Vector3 localVelocityIn = velocityMarker.transform.localPosition;
        velocityMarker.transform.SetParent(PortalOut.transform);
        velocityMarker.transform.localPosition = new Vector3(localVelocityIn.x, localVelocityIn.y, localVelocityIn.z);
        oldPortalTransform = transform.position;
    }

    void HandleTravellers()
    {
        for (int i = 0; i < trackedTravellers.Count; i++)
        {
            PortalTraveller traveller = trackedTravellers[i];
            Transform travellerT = traveller.transform;


            var m = linkedPortal.transform.localToWorldMatrix * transform.worldToLocalMatrix * travellerT.localToWorldMatrix;

            Vector3 offsetFromPortal;

            if (traveller.tag != "Player")
            {
                offsetFromPortal = travellerT.position - transform.position;
            }
            else
            {
                offsetFromPortal = (travellerT.GetChild(0).GetChild(0).position) - transform.position;
            }
            Vector3 portalToPlayer = playerCamera.transform.position - transform.GetChild(2).GetChild(0).position;
            float dotProduct = Vector3.Dot(transform.up, portalToPlayer);

            int portalSide = System.Math.Sign(Vector3.Dot(offsetFromPortal, transform.forward));
            int portalSideOld = System.Math.Sign(Vector3.Dot(traveller.previousOffsetFromPortal, transform.forward));

            traveller.graphicsClone.transform.SetPositionAndRotation(m.GetColumn(3), m.rotation);
            traveller.graphicsClone.transform.position = traveller.graphicsClone.transform.position - 0.891f * traveller.graphicsClone.transform.up - 0.7f * traveller.graphicsClone.transform.forward;
            //UpdateSliceParams(traveller);
            traveller.previousOffsetFromPortal = offsetFromPortal;

            if (teleportFrame)
            {
                teleportFrame = false;
            }


            // Teleport the traveller if it has crossed from one side of the portal to the other
            if (portalSide != portalSideOld && oldPortalTransform == transform.position)
            {
                var positionOld = travellerT.position;
                var rotOld = travellerT.rotation;

                //traveller.graphicsClone.transform.SetPositionAndRotation(positionOld, rotOld);

                if (traveller.tag != "Player")
                {
                    if ((new Vector3(m.GetColumn(3).x, m.GetColumn(3).y, m.GetColumn(3).z) - linkedPortal.transform.position).magnitude < 4)
                        traveller.Teleport(transform, linkedPortal.transform, m.GetColumn(3), m.rotation);

                }
                else
                {
                    Quaternion rotation = Quaternion.Euler(bodyCam.eulerAngles);
                    Vector3 velocityOut = velocityMarker.transform.position - PortalOut.transform.position;

                    if ((bodyCam.position - linkedPortal.transform.position).magnitude < 3 || isRendering)
                    {

                        //Teleport him!
                        player.GetComponent<FirstPersonAIO>().portalRotation(rotation, velocityOut);
                        player.transform.position = bodyCam.position;

                        teleportFrame = true;

                        playerIsOverlapping = true;

                        Material tempPlayerSkybox = playerCam.GetComponent<Skybox>().material;
                        Material tempPortalSkybox = portalCam.GetComponent<Skybox>().material;

                        Transform[] children;
                        Transform[] skeleChildren;
                        Transform[] travellerChildren;

                        if (Level.layer == 11)
                        {
                            children = Level.GetComponentsInChildren<Transform>();
                            foreach (Transform go in children)
                            {
                                if (go.gameObject.layer != 13 && go.gameObject.tag != "DirectionalLight")
                                    go.gameObject.layer = 12;

                            }
                            foreach (PortalTraveller traveller2 in portalTravellers)
                            {
                                travellerChildren = traveller2.GetComponentsInChildren<Transform>();
                                foreach (Transform go2 in travellerChildren)
                                {
                                    if (go2.gameObject.layer != 9 && go2.gameObject.tag != "DirectionalLight")
                                        go2.gameObject.layer = 12;
                                }
                            }
                        }
                        else
                        {
                            children = Level.GetComponentsInChildren<Transform>();

                            foreach (Transform go in children)
                            {
                                if (go.gameObject.layer != 13 && go.gameObject.tag != "DirectionalLight")
                                    go.gameObject.layer = 11;                              
                            }
                            if (Skeleton != null)
                            {
                                skeleChildren = Skeleton.GetComponentsInChildren<Transform>();
                                foreach (Transform sgo in skeleChildren)
                                {
                                    if (sgo.gameObject.layer == 11 && sgo.gameObject.tag == "Skeleton" && sgo.gameObject.GetComponent<MeshRenderer>() != null)
                                    {
                                        sgo.GetComponent<MeshRenderer>().enabled = false;
                                        if (sgo.gameObject.GetComponent<MeshCollider>() != null)
                                            sgo.GetComponent<MeshCollider>().enabled = false;
                                    }

                                    if (sgo.gameObject.layer == 12 && sgo.gameObject.tag == "Skeleton" && sgo.gameObject.GetComponent<MeshRenderer>() != null)
                                    {
                                        sgo.GetComponent<MeshRenderer>().enabled = true;
                                        if (sgo.gameObject.GetComponent<MeshCollider>() != null)
                                            sgo.GetComponent<MeshCollider>().enabled = true;
                                    }
                                }
                            }
                            foreach (PortalTraveller traveller2 in portalTravellers)
                            {
                                travellerChildren = traveller2.GetComponentsInChildren<Transform>();
                                foreach (Transform go2 in travellerChildren)
                                {
                                    if (go2.gameObject.layer != 9 && go2.gameObject.tag != "DirectionalLight")
                                        go2.gameObject.layer = 11;
                                }
                            }
                        }

                        playerCam.GetComponent<Skybox>().material = tempPortalSkybox;
                        portalCam.GetComponent<Skybox>().material = tempPlayerSkybox;
                        linkedPortal.transform.GetChild(1).GetComponent<Skybox>().material = tempPlayerSkybox;


                        foreach (PortalTraveller go in portalTravellers)
                        {
                            if (go.tag != "Player")
                            {
                                if (go.gameObject.layer == 11)
                                {
                                    go.transform.GetChild(0).GetComponent<Renderer>().material = sunMat;
                                }
                                else
                                {
                                    go.transform.GetChild(0).GetComponent<Renderer>().material = moonMat;
                                }
                            }
                        }






                        //traveller.graphicsClone.GetComponent<MeshRenderer>().enabled = false;

                        traveller.graphicsClone.transform.position = bodyCam.position;
                        traveller.graphicsClone.transform.rotation = player.transform.GetChild(1).rotation;
                        traveller.graphicsClone.transform.position = traveller.graphicsClone.transform.position - 0.891f * traveller.graphicsClone.transform.up - 0.7f * traveller.graphicsClone.transform.forward;

                        Light currentDirectionalLight = RenderSettings.sun;
                        if (currentDirectionalLight == DirectionalMoonLight)
                            RenderSettings.sun = DirectionalSunLight;
                        else
                            RenderSettings.sun = DirectionalMoonLight;

                        teleportFrame = true;

                        UpdateSliceParams(traveller);

                        // Can't rely on OnTriggerEnter/Exit to be called next frame since it depends on when FixedUpdate runs
                        linkedPortal.OnTravellerEnterPortal(traveller);
                        trackedTravellers.RemoveAt(i);
                        i--;

                    }
                }






            }
            else
            {

                traveller.graphicsClone.transform.SetPositionAndRotation(m.GetColumn(3), m.rotation);
                traveller.graphicsClone.transform.position = traveller.graphicsClone.transform.position - 0.891f * traveller.graphicsClone.transform.up - 0.7f * traveller.graphicsClone.transform.forward;
                //UpdateSliceParams(traveller);
                traveller.previousOffsetFromPortal = offsetFromPortal;
            }


            //Vector3 cloneDistance = traveller.graphicsClone.transform.position - playerCam.transform.position;
            //if (cloneDistance.magnitude < 3)
            //{
            //    Debug.Log("close");
            //    traveller.graphicsClone.transform.parent.SetPositionAndRotation(m.GetColumn(3), m.rotation);
            //}


        }
        //foreach (PortalTraveller test in trackedTravellers)
        //{
        //    var traveller = test.GetComponent<PortalTraveller>();
        //    if ((traveller.transform.position - transform.position).magnitude > 5 && trackedTravellers.Contains(traveller))
        //        trackedTravellers.Remove(traveller);
        //}



        var traveller3 = player.GetComponent<PortalTraveller>();
        if (traveller3 && trackedTravellers.Contains(traveller3))
        {
            if ((traveller3.transform.position - transform.position).magnitude > (traveller3.transform.position - linkedPortal.transform.position).magnitude)
            {
                if ((traveller3.transform.position - transform.position).magnitude > 3 || portalOldPos != transform.position)
                {
                    trackedTravellers.Remove(traveller3);
                    traveller3.graphicsClone.SetActive(false);
                }
            }
        }

        portalOldPos = transform.position;


    }

    // Called before any portal cameras are rendered for the current frame
    public void PrePortalRender()
    {



        foreach (var traveller in trackedTravellers)
        {

            UpdateSliceParams(traveller);
            {


                if (traveller.name == "FirstPerson-AIO")
                {
                    traveller.graphicsClone.transform.position = bodyCam.position;
                    traveller.graphicsClone.transform.rotation = bodyCam.rotation;
                    traveller.graphicsClone.transform.position = traveller.graphicsClone.transform.position - 0.891f * traveller.graphicsClone.transform.up - 0.7f * traveller.graphicsClone.transform.forward;
                }
            }

        }


    }

    // Manually render the camera attached to this portal
    // Called after PrePortalRender, and before PostPortalRender
    public void Render()
    {
        //HandleTravellers();

        // Skip rendering the view from this portal if player is not looking at the linked portal
        //if (!CameraUtility.VisibleFromCamera(linkedPortal.screen, playerCam))
        //{
        //    return;
        //}

        // Hide screen so that camera can see through portal
        screen.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
        linkedPortal.screen.material.SetInt("displayMask", 0);

        var localToWorldMatrix = playerCam.transform.localToWorldMatrix;
        var renderPositions = new Vector3[recursionLimit];
        var renderRotations = new Quaternion[recursionLimit];

        int startIndex = 0;
        portalCam.projectionMatrix = playerCam.projectionMatrix;
        for (int i = 0; i < recursionLimit; i++)
        {
            if (i > 0)
            {
                // No need for recursive rendering if linked portal is not visible through this portal
                if (!CameraUtility.BoundsOverlap(screenMeshFilter, linkedPortal.screenMeshFilter, portalCam))
                {
                    break;
                }
            }

            localToWorldMatrix = transform.localToWorldMatrix * linkedPortal.transform.worldToLocalMatrix * localToWorldMatrix;
            int renderOrderIndex = recursionLimit - i - 1;
            renderPositions[renderOrderIndex] = localToWorldMatrix.GetColumn(3);
            renderRotations[renderOrderIndex] = localToWorldMatrix.rotation;
            portalCam.transform.SetPositionAndRotation(renderPositions[renderOrderIndex], renderRotations[renderOrderIndex]);
            startIndex = renderOrderIndex;
        }

        tempLayer = Level.layer;
        playerLayer = Level.layer;

        Material tempPlayerSkybox2 = playerCam.GetComponent<Skybox>().material;
        Material tempPortalSkybox2 = portalCam.GetComponent<Skybox>().material;

        Light tempDirectionalLight = RenderSettings.sun;
        Light playerDirectionalLight = RenderSettings.sun;
        Light portalAlternateDirectionalLight;

        if (playerDirectionalLight == DirectionalMoonLight)
            portalAlternateDirectionalLight = DirectionalSunLight;
        else
            portalAlternateDirectionalLight = DirectionalMoonLight;

        if (Level.layer == 11)
            portalAlternatingLayerMask = 12;
        else
            portalAlternatingLayerMask = 11;


        for (int i = startIndex; i < recursionLimit; i++)
        {

            portalCam.transform.SetPositionAndRotation(renderPositions[i], renderRotations[i]);

            HandleTravellers();

            SetNearClipPlane();
            HandleClipping();

            //if (portalTravellers != null)
            //{
            //    foreach (PortalTraveller traveller in portalTravellers)
            //    {
            //        UpdateSliceParams(traveller);
            //    }
            //}

            Transform[] children;
            Transform[] skeleChildren;

            children = Level.GetComponentsInChildren<Transform>();

            Transform[] travellerChildren;

            if ((recursionLimit - i) % 2 == 1)
            {
                portalCam.GetComponent<Skybox>().material = tempPortalSkybox2;
                foreach (Transform go in children)
                {
                    if (go.gameObject.layer != 13 && go.gameObject.tag != "DirectionalLight")
                        go.gameObject.layer = portalAlternatingLayerMask.value;
                }
                if (Skeleton != null)
                {
                    skeleChildren = Skeleton.GetComponentsInChildren<Transform>();
                    foreach (Transform sgo in skeleChildren)
                    {
                        if (sgo.gameObject.layer == 11 && sgo.gameObject.tag == "Skeleton" && sgo.gameObject.GetComponent<MeshRenderer>() != null)
                        {
                            sgo.GetComponent<MeshRenderer>().enabled = false;
                            if (sgo.gameObject.GetComponent<MeshCollider>() != null)
                                sgo.GetComponent<MeshCollider>().enabled = false;
                        }

                        if (sgo.gameObject.layer == 12 && sgo.gameObject.tag == "Skeleton" && sgo.gameObject.GetComponent<MeshRenderer>() != null)
                        {
                            sgo.GetComponent<MeshRenderer>().enabled = true;
                            if (sgo.gameObject.GetComponent<MeshCollider>() != null)
                                sgo.GetComponent<MeshCollider>().enabled = true;
                        }
                    }
                }
                foreach (PortalTraveller traveller in portalTravellers)
                {
                    travellerChildren = traveller.GetComponentsInChildren<Transform>();
                    foreach (Transform go2 in travellerChildren)
                    {
                        if (go2.gameObject.layer != 9 && go2.gameObject.tag != "DirectionalLight")
                            go2.gameObject.layer = portalAlternatingLayerMask.value;
                    }
                }

                RenderSettings.sun = portalAlternateDirectionalLight;
            }
            else
            {

                portalCam.GetComponent<Skybox>().material = tempPlayerSkybox2;
                foreach (Transform go in children)
                {
                    if (go.gameObject.layer != 13 && go.gameObject.tag != "DirectionalLight")
                        go.gameObject.layer = playerLayer.value;
                }
                foreach (PortalTraveller traveller in portalTravellers)
                {
                    travellerChildren = traveller.GetComponentsInChildren<Transform>();
                    foreach (Transform go2 in travellerChildren)
                    {
                        if (go2.gameObject.layer != 9 && go2.gameObject.tag != "DirectionalLight")
                            go2.gameObject.layer = playerLayer.value;
                    }
                }
                RenderSettings.sun = playerDirectionalLight;
            }
            foreach (PortalTraveller go in portalTravellers)
            {
                if (go.tag != "Player")
                {
                    if (go.gameObject.layer == 11)
                    {
                        go.transform.GetChild(0).GetComponent<Renderer>().material = sunMat;
                    }
                    else
                    {
                        go.transform.GetChild(0).GetComponent<Renderer>().material = moonMat;
                    }
                }
            }
            portalCam.Render();

            if (i == startIndex)
            {
                linkedPortal.screen.material.SetInt("displayMask", 1);
            }


            foreach (Transform go in children)
            {
                if (go.gameObject.layer != 13 && go.gameObject.tag != "DirectionalLight")
                    go.gameObject.layer = tempLayer;
            }
            if (Skeleton != null)
            {
                skeleChildren = Skeleton.GetComponentsInChildren<Transform>();
                foreach (Transform sgo in skeleChildren)
                {
                    if (sgo.gameObject.layer == 11 && sgo.gameObject.tag == "Skeleton" && sgo.gameObject.GetComponent<MeshRenderer>() != null)
                    {
                        sgo.GetComponent<MeshRenderer>().enabled = false;
                        if (sgo.gameObject.GetComponent<MeshCollider>() != null)
                            sgo.GetComponent<MeshCollider>().enabled = false;
                    }

                    if (sgo.gameObject.layer == 12 && sgo.gameObject.tag == "Skeleton" && sgo.gameObject.GetComponent<MeshRenderer>() != null)
                    {
                        sgo.GetComponent<MeshRenderer>().enabled = true;
                        if (sgo.gameObject.GetComponent<MeshCollider>() != null)
                            sgo.GetComponent<MeshCollider>().enabled = true;
                    }
                }
            }
            foreach (PortalTraveller traveller in portalTravellers)
            {
                travellerChildren = traveller.GetComponentsInChildren<Transform>();
                foreach (Transform go2 in travellerChildren)
                {
                    if (go2.gameObject.layer != 9 && go2.gameObject.tag != "DirectionalLight")
                        go2.gameObject.layer = tempLayer;

                }
            }
            foreach (PortalTraveller go in portalTravellers)
            {
                if (go.tag != "Player")
                {
                    if (go.gameObject.layer == 11)
                    {
                        go.transform.GetChild(0).GetComponent<Renderer>().material = sunMat;
                    }
                    else
                    {
                        go.transform.GetChild(0).GetComponent<Renderer>().material = moonMat;

                    }
                }
            }
            RenderSettings.sun = tempDirectionalLight;
            //portalCam.Render();

        }


        // Unhide objects hidden at start of render
        screen.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
        CreateViewTexture();
    }

    void HandleClipping()
    {
        // There are two main graphical issues when slicing travellers
        // 1. Tiny sliver of mesh drawn on backside of portal
        //    Ideally the oblique clip plane would sort this out, but even with 0 offset, tiny sliver still visible
        // 2. Tiny seam between the sliced mesh, and the rest of the model drawn onto the portal screen
        // This function tries to address these issues by modifying the slice parameters when rendering the view from the portal
        // Would be great if this could be fixed more elegantly, but this is the best I can figure out for now
        const float hideDst = -1000;
        const float showDst = 1000;
        float screenThickness = linkedPortal.ProtectScreenFromClipping(portalCam.transform.position);

        foreach (var traveller in trackedTravellers)
        {
            //portalCamPos
            if (traveller.tag != "Player")
            {
                if (SameSideOfPortal(traveller.transform.position, portalCamPos))
                {
                    // Addresses issue 1
                    traveller.SetSliceOffsetDst(hideDst, false);
                }
                else
                {
                    // Addresses issue 2
                    traveller.SetSliceOffsetDst(showDst, false);
                }
            }
            else
            {
                if (SameSideOfPortal(traveller.transform.GetChild(0).GetChild(0).position, portalCamPos))
                {
                    // Addresses issue 1
                    traveller.SetSliceOffsetDst(hideDst, false);
                }
                else
                {
                    // Addresses issue 2
                    traveller.SetSliceOffsetDst(showDst, false);
                }
            }

            int cloneSideOfLinkedPortal;
            if (traveller.tag != "Player")
            {
                cloneSideOfLinkedPortal = -SideOfPortal(traveller.transform.position);
            }
            else
            {
                cloneSideOfLinkedPortal = -SideOfPortal(traveller.transform.GetChild(0).GetChild(0).position);
            }

            bool camSameSideAsClone = linkedPortal.SideOfPortal(portalCamPos) == cloneSideOfLinkedPortal;
            if (camSameSideAsClone)
            {
                traveller.SetSliceOffsetDst(screenThickness, true);
            }
            else
            {
                traveller.SetSliceOffsetDst(-screenThickness, true);
            }
        }

        var offsetFromPortalToCam = portalCamPos - transform.GetChild(0).GetChild(0).position;
        foreach (var linkedTraveller in linkedPortal.trackedTravellers)
        {
            var travellerPos = linkedTraveller.graphicsObject.transform.position;
            var clonePos = linkedTraveller.graphicsClone.transform.position;
            // Handle clone of linked portal coming through this portal:
            bool cloneOnSameSideAsCam = linkedPortal.SideOfPortal(clonePos) != SideOfPortal(portalCamPos);
            if (cloneOnSameSideAsCam)
            {
                // Addresses issue 1
                linkedTraveller.SetSliceOffsetDst(hideDst, true);
            }
            else
            {
                // Addresses issue 2
                linkedTraveller.SetSliceOffsetDst(showDst, true);
            }

            // Ensure traveller of linked portal is properly sliced, in case it's visible through this portal:
            bool camSameSideAsTraveller = linkedPortal.SameSideOfPortal(linkedTraveller.transform.position, portalCamPos);
            if (camSameSideAsTraveller)
            {
                linkedTraveller.SetSliceOffsetDst(screenThickness, false);
            }
            else
            {
                linkedTraveller.SetSliceOffsetDst(-screenThickness, false);
            }
        }
    }

    // Called once all portals have been rendered, but before the player camera renders
    public void PostPortalRender()
    {

        foreach (var traveller in trackedTravellers)
        {
            UpdateSliceParams(traveller);
        }
        ProtectScreenFromClipping(playerCam.transform.position);

    }
    void CreateViewTexture()
    {
        if (viewTexture == null || viewTexture.width != Screen.width || viewTexture.height != Screen.height)
        {
            if (viewTexture != null && teleportFrame)
            {
                viewTexture.Release();
            }

            viewTexture = new RenderTexture(Screen.width, Screen.height, 4);

            portalCam.targetTexture = viewTexture;
            linkedPortal.screen.material.SetTexture("_MainTex", viewTexture);

        }
    }

    // Sets the thickness of the portal screen so as not to clip with camera near plane when player goes through
    float ProtectScreenFromClipping(Vector3 viewPoint)
    {
        float halfHeight = playerCam.nearClipPlane * Mathf.Tan(playerCam.fieldOfView * 0.5f * Mathf.Deg2Rad);
        float halfWidth = halfHeight * playerCam.aspect;
        float dstToNearClipPlaneCorner = new Vector3(halfWidth, halfHeight, playerCam.nearClipPlane).magnitude;
        float screenThickness = dstToNearClipPlaneCorner;

        Transform screenT = screen.transform;
        bool camFacingSameDirAsPortal = Vector3.Dot(transform.forward, transform.position - viewPoint) > 0;
        screenT.localScale = new Vector3(screenT.localScale.x, screenT.localScale.y, screenThickness);
        //screenT.localPosition = Vector3.forward * screenThickness * ((camFacingSameDirAsPortal) ? 0.5f : -0.5f);
        return screenThickness;
    }

    void UpdateSliceParams(PortalTraveller traveller)
    {
        // Calculate slice normal
        int side = SideOfPortal(playerCam.transform.position);

        Vector3 sliceNormal = transform.forward * -side;
        Vector3 cloneSliceNormal = linkedPortal.transform.forward * side;

        // Calculate slice centre
        Vector3 slicePos = transform.position;
        Vector3 cloneSlicePos = linkedPortal.transform.position;

        // Adjust slice offset so that when player standing on other side of portal to the object, the slice doesn't clip through
        float sliceOffsetDst = 0;
        float cloneSliceOffsetDst = 0;
        float screenThickness = screen.transform.localScale.z;
        bool playerSameSideAsTraveller;
        if (traveller.tag != "Player")
        {
            playerSameSideAsTraveller = SameSideOfPortal(playerCam.transform.position, traveller.transform.position);
        }
        else
        {
            playerSameSideAsTraveller = SameSideOfPortal(playerCam.transform.position, traveller.transform.GetChild(0).GetChild(0).position);
        }

        if (!playerSameSideAsTraveller)
        {
            sliceOffsetDst = -screenThickness;
        }
        bool playerSameSideAsCloneAppearing = side != linkedPortal.SideOfPortal(playerCam.transform.position);
        if (!playerSameSideAsCloneAppearing)
        {
            cloneSliceOffsetDst = -screenThickness;
        }

        // Apply parameters
        for (int j = 0; j < traveller.originalMaterials.Length; j++)
        {
            traveller.originalMaterials[j].SetVector("sliceCentre", slicePos);
            traveller.originalMaterials[j].SetVector("sliceNormal", sliceNormal);
            traveller.originalMaterials[j].SetFloat("sliceOffsetDst", sliceOffsetDst);

            traveller.cloneMaterials[j].SetVector("sliceCentre", cloneSlicePos);
            traveller.cloneMaterials[j].SetVector("sliceNormal", cloneSliceNormal);
            traveller.cloneMaterials[j].SetFloat("sliceOffsetDst", cloneSliceOffsetDst);

        }

    }

    // Use custom projection matrix to align portal camera's near clip plane with the surface of the portal
    // Note that this affects precision of the depth buffer, which can cause issues with effects like screenspace AO
    void SetNearClipPlane()
    {
        // Learning resource:
        // http://www.terathon.com/lengyel/Lengyel-Oblique.pdf
        Transform clipPlane = transform;
        int dot = System.Math.Sign(Vector3.Dot(clipPlane.forward, transform.GetChild(2).position - portalCam.transform.position));


        Vector3 camSpacePos = portalCam.worldToCameraMatrix.MultiplyPoint(clipPlane.position);
        Vector3 camSpaceNormal = portalCam.worldToCameraMatrix.MultiplyVector(clipPlane.forward) * dot;
        float camSpaceDst = -Vector3.Dot(camSpacePos, camSpaceNormal) + nearClipOffset;

        // Don't use oblique clip plane if very close to portal as it seems this can cause some visual artifacts

        if (Mathf.Abs(camSpaceDst) > nearClipLimit)
        {

            Vector4 clipPlaneCameraSpace = new Vector4(camSpaceNormal.x, camSpaceNormal.y, camSpaceNormal.z, camSpaceDst);

            // Update projection based on new clip plane
            // Calculate matrix with player cam so that player camera settings (fov, etc) are used
            portalCam.projectionMatrix = playerCam.CalculateObliqueMatrix(clipPlaneCameraSpace);
        }
        else
        {

            portalCam.projectionMatrix = playerCam.projectionMatrix;

        }
    }

    void OnTravellerEnterPortal(PortalTraveller traveller)
    {
        if (!trackedTravellers.Contains(traveller))
        {
            traveller.EnterPortalThreshold();

            Transform tempTraveller;
            tempTraveller = traveller.transform;
            if (traveller.tag != "Player")
            {
                traveller.previousOffsetFromPortal = tempTraveller.position - transform.position;
            }
            else
            {
                traveller.previousOffsetFromPortal = tempTraveller.GetChild(0).GetChild(0).position - transform.position;
            }
            trackedTravellers.Add(traveller);
        }
    }
    void OnTriggerExit(Collider other)
    {
        var traveller = other.GetComponent<PortalTraveller>();
        if (traveller && trackedTravellers.Contains(traveller))
        {
            traveller.ExitPortalThreshold();
            //traveller.graphicsClone.SetActive(false);
            //trackedTravellers.Remove(traveller);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        var traveller = other.GetComponent<PortalTraveller>();
        if (traveller)
        {
            OnTravellerEnterPortal(traveller);
        }
        if (other.tag == "Player")
        {
            playerIsOverlapping = false;
        }

    }



    /*
     ** Some helper/convenience stuff:
     */

    int SideOfPortal(Vector3 pos)
    {
        return System.Math.Sign(Vector3.Dot(pos - transform.position, transform.forward));
    }

    bool SameSideOfPortal(Vector3 posA, Vector3 posB)
    {
        return SideOfPortal(posA) == SideOfPortal(posB);
    }

    Vector3 portalCamPos
    {
        get
        {
            return portalCam.transform.position;
        }
    }

    void OnValidate()
    {
        if (linkedPortal != null)
        {
            linkedPortal.linkedPortal = this;
        }
    }

    void WhatPortalSide()
    {
        Vector3 portalToPlayer = playerCamera.transform.position - transform.GetChild(2).GetChild(0).position;
        if (portalToPlayer.magnitude < 3)
        {
            float dotProduct = Vector3.Dot(transform.forward, portalToPlayer);
        }

    }
}