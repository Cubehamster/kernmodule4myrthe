using UnityEngine;
using System.Collections;
using FMOD;

public class Rotator : MonoBehaviour
{
    public float speed = 10f;
    public Transform linkedPortal;
    public Transform player;
    public Transform playerCamera;

    public bool isRotating = false;

    private float lerpTime = 2;
    private float currentLerpTime = 0;
    [SerializeField] private float targetEulerZ;
    private float SmoothEulerZ;
    private float offset;
    private float smoothDampSpeed = 0.3f;
    public Transform portalRotationReferenceMarker;
    public Transform portalAngleMarker;
    private GameObject PortalType;
    private GameObject oldPortalType;
    private bool portalIsActive;
    [SerializeField] private GameObject PortalLocker;
    public GameObject glas;
    public float alpha;
    private float vertexOffset;
    public bool isLocked = false;
    public bool hasFloor = false;
    public bool lockOverride = false;
    public bool lookingAtPortal = false;
    public bool hasPressedMouse = false;

    float refEulerZ = 0.0f;
    float refScale = 0.0f;
    public float scale;

    [SerializeField] private float portalRotationSpeed;
    private float portalAngle;
    private float oldPortalAngle;
    public GameObject SpinLeft;
    public GameObject SpinRight;

    private void Start()
    {
        PortalType = null;
        targetEulerZ = linkedPortal.localRotation.eulerAngles.z;
        portalAngleMarker.GetComponent<MeshRenderer>().enabled = false;

    }

    void Update()
    {
        oldPortalAngle = linkedPortal.localRotation.eulerAngles.z;

        scale = Mathf.SmoothDamp(scale, 1, ref refScale, 0.5f);
        transform.localScale = new Vector3(scale, scale, 1);

        GlassIntensity();
        portalLockerSetter();
        RaycastPortalChecker();
        if (Input.GetKeyDown(KeyCode.Mouse0) && lookingAtPortal && oldPortalType == PortalType)
        {
            hasPressedMouse = true;
            //portalAngleMarker.GetComponent<MeshRenderer>().enabled = true;
        }

        if (!Input.GetKey(KeyCode.Mouse0) || !lookingAtPortal || oldPortalType != PortalType)
        {
            hasPressedMouse = false;
            portalAngleMarker.GetComponent<MeshRenderer>().enabled = false;
        }

        if (PortalType != null)
        {
            if (!hasPressedMouse || !lookingAtPortal)
            {
                smoothDampSpeed = 0.3f;
                targetEulerZ = linkedPortal.localRotation.eulerAngles.z;
                if ((targetEulerZ + 719) % 360 >= 45 && (targetEulerZ + 719) % 360 < 135)
                    targetEulerZ = 90;
                else if ((targetEulerZ + 719) % 360 >= 135 && (targetEulerZ + 719) % 360 < 225)
                    targetEulerZ = 180;
                else if ((targetEulerZ + 719) % 360 >= 225 && (targetEulerZ + 719) % 360 < 315)
                    targetEulerZ = 270;
                else
                    targetEulerZ = 0;
            }
            if (PortalType.name == transform.name)
            {
                //Debug.Log(PortalType.name + " + "  + hasPressedMouse + " + "  + lookingAtPortal + " + " + targetEulerZ);
                if (hasPressedMouse)
                {
                    //portalAngleMarker.GetComponent<MeshRenderer>().enabled = true;
                    StartCoroutine(PortalDelayedUnlock());
                }


            }
            if ((targetEulerZ + 360) % 360 >= 0 && (targetEulerZ + 360) % 360 <= 120 && PortalType.name == transform.name)
            {
                SmoothEulerZ = Mathf.SmoothDamp((linkedPortal.localRotation.eulerAngles.z + 720 + 120) % 360, (targetEulerZ + 720 + 120) % 360, ref refEulerZ, smoothDampSpeed);
                linkedPortal.localRotation = Quaternion.Euler(linkedPortal.localRotation.eulerAngles.x, linkedPortal.localRotation.eulerAngles.y, 0) * Quaternion.Euler(0, 0, SmoothEulerZ - 120);
            }
            else if (PortalType.name == transform.name)
            {
                SmoothEulerZ = Mathf.SmoothDamp((linkedPortal.localRotation.eulerAngles.z + 720 - 45) % 360, (targetEulerZ + 720 - 45) % 360, ref refEulerZ, smoothDampSpeed);
                linkedPortal.localRotation = Quaternion.Euler(linkedPortal.localRotation.eulerAngles.x, linkedPortal.localRotation.eulerAngles.y, 0) * Quaternion.Euler(0, 0, SmoothEulerZ + 45);
            }
        }
        if ((linkedPortal.localRotation.eulerAngles.z + 361) % 90 >= 1.1f)
        {
            linkedPortal.GetComponent<Rotator>().isRotating = true;
            isRotating = true;
        }
        else
        {
            isRotating = false;
        }


        oldPortalType = PortalType;

        portalAngle = linkedPortal.localRotation.eulerAngles.z;


        if (((oldPortalAngle + 720) % 360 - (portalAngle + 720) % 360) / Time.deltaTime > 1000)
            portalRotationSpeed = (((oldPortalAngle + 720) % 360) - ((portalAngle + 720) % 360 + 360)) / Time.deltaTime / 2;
        else if (((oldPortalAngle + 720) % 360 - (portalAngle + 720) % 360) / Time.deltaTime < -1000)
            portalRotationSpeed = (((oldPortalAngle + 720) % 360 + 360) - ((portalAngle + 720) % 360)) / Time.deltaTime / 2;
        else
            portalRotationSpeed = (((oldPortalAngle + 720) % 360) - ((portalAngle + 720) % 360)) / Time.deltaTime / 2;

        portalRotationSpeed = Mathf.Clamp(portalRotationSpeed, -100, 100);

        if (portalRotationSpeed <= -1)
        {
            SpinRight.SetActive(false);
            SpinLeft.SetActive(true);
            SpinLeft.GetComponent<FMODUnity.StudioEventEmitter>().SetParameter("RotationSpeed", -portalRotationSpeed);
        }
        else if (portalRotationSpeed >= 1)
        {
            SpinRight.SetActive(true);
            SpinLeft.SetActive(false);
            SpinRight.GetComponent<FMODUnity.StudioEventEmitter>().SetParameter("RotationSpeed", portalRotationSpeed);
        }

        if (portalRotationSpeed < 1f && portalRotationSpeed > -1f)
        {
            SpinRight.SetActive(false);
            SpinLeft.SetActive(false);
        }
    }

    IEnumerator PortalDelayedUnlock()
    {

        yield return new WaitForSeconds(0.6f);
        isLocked = false;

    }

    private void RaycastPortalChecker()
    {
        RaycastHit[] hits;
        hits = Physics.RaycastAll(playerCamera.position, playerCamera.forward, 6);
        lookingAtPortal = false;
        for (int i = 0; i < hits.Length; i++)
        {
            RaycastHit hit = hits[i];

            if (hits[i].transform.name == "TestSurface" && hit.transform.parent.parent.childCount == 2)
            {
                //Debug.Log(hit.transform.parent.parent.GetChild(1).name);
                if (hit.transform.parent.parent.GetChild(1).name == "MoonPortal" || hit.transform.parent.parent.GetChild(1).name == "SunPortal")
                {
                    PortalType = hit.transform.parent.parent.GetChild(1).gameObject;
                    lookingAtPortal = true;
                    //portalAngleMarker.GetComponent<MeshRenderer>().enabled = true;
                }
                else
                    portalAngleMarker.GetComponent<MeshRenderer>().enabled = false;

                if (hit.transform.parent.parent.childCount == 2)
                {
                    portalIsActive = true;
                }
                else
                {
                    portalIsActive = false;
                }


                if (Input.GetKeyDown(KeyCode.Mouse0) && portalIsActive && lookingAtPortal && !isRotating)
                {
                    offset = linkedPortal.localRotation.eulerAngles.z;
                    portalRotationReferenceMarker.position = hit.point;
                    portalRotationReferenceMarker.parent = hit.transform;
                    portalRotationReferenceMarker.transform.localPosition = new Vector3(portalRotationReferenceMarker.transform.localPosition.x, portalRotationReferenceMarker.transform.localPosition.y, 1f);
                    portalRotationReferenceMarker.transform.localRotation = Quaternion.Euler(0, 0, 0);
                    portalRotationReferenceMarker.transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);
                    smoothDampSpeed = 0.1f;
 
                }
                if (PortalType != null)
                {
                    if (Input.GetKey(KeyCode.Mouse0) && portalIsActive && hasPressedMouse)
                    {
                        isLocked = true;
                        portalAngleMarker.position = hit.point;
                        portalAngleMarker.parent = hit.transform;
                        portalAngleMarker.GetComponent<MeshRenderer>().enabled = true;
                        portalAngleMarker.transform.localPosition = new Vector3(portalAngleMarker.transform.localPosition.x, portalAngleMarker.transform.localPosition.y, 1f);
                        portalAngleMarker.transform.localRotation = Quaternion.Euler(0, 0, 0);
                        portalAngleMarker.transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);

                        float Angle1 = Mathf.Asin(new Vector2(portalAngleMarker.transform.localPosition.x, portalAngleMarker.transform.localPosition.y).normalized.y) * 180 / Mathf.PI;
                        float Angle2 = Mathf.Acos(new Vector2(portalAngleMarker.transform.localPosition.x, portalAngleMarker.transform.localPosition.y).normalized.x) * 180 / Mathf.PI;
                        float Angle3 = Angle2 * System.Math.Sign(Angle1);

                        float Angle4 = Mathf.Asin(new Vector2(portalRotationReferenceMarker.transform.localPosition.x, portalRotationReferenceMarker.transform.localPosition.y).normalized.y) * 180 / Mathf.PI;
                        float Angle5 = Mathf.Acos(new Vector2(portalRotationReferenceMarker.transform.localPosition.x, portalRotationReferenceMarker.transform.localPosition.y).normalized.x) * 180 / Mathf.PI;
                        float Angle6 = Angle5 * System.Math.Sign(Angle4);

                        if (PortalType.name == "MoonPortal")
                        {
                            targetEulerZ = ((Angle6 + 360) % 360) - ((Angle3 + 360) % 360) + offset;
                        }

                        else if (PortalType.name == "SunPortal")
                        {
                            targetEulerZ = ((Angle3 + 360) % 360) - ((Angle6 + 360) % 360) + offset;
                        }

  

                    }
                }
            }
            else
            {
                portalIsActive = false;
            }
            if (hits.Length == 0)
            {
                lookingAtPortal = false;
            }
        }
    }

    private void GlassIntensity()
    {
        if ((!hasFloor && !lockOverride) || (isRotating) || scale < 0.99f)
        {
            isLocked = true;
        }
        else
        {
            isLocked = false;
        }

        if (isLocked || isRotating)
        {
            alpha = Mathf.Lerp(alpha, 0.6f, 0.045f);
            glas.GetComponent<Renderer>().material.SetFloat("_Intensity", alpha);
        }
        else if (!isLocked && !lockOverride)
        {
            alpha = Mathf.Lerp(alpha, 0, 0.045f);
            glas.GetComponent<Renderer>().material.SetFloat("_Intensity", alpha);
        }
        if (isLocked && PortalLocker != null && !lockOverride)
        {
            PortalLocker.layer = 0;
            //if ((player.position - transform.position).magnitude < 5 && !isLocked)
            //{
            //    Debug.Log("unlocking");
            //    linkedPortal.GetComponent<Rotator>().isLocked = false;
            //}
        }
        else if (PortalLocker != null)
        {
            PortalLocker.layer = 15;
            if ((player.position - transform.position).magnitude < 4 && !isLocked)
            {
                linkedPortal.GetComponent<Rotator>().lockOverride = true;
                linkedPortal.GetComponent<Rotator>().isLocked = false;
            }
            else
            {
                StartCoroutine(DelayedLockOverWrite());
            }
        }

    }

    IEnumerator DelayedLock()
    {
        //if (lockOverride)
        //    PortalLocker.layer = 0;
        yield return new WaitForSeconds(0.2f);
        if (!lockOverride)
            PortalLocker.layer = 0;
    }

    private void portalLockerSetter()
    {
        PortalLocker = transform.parent.GetChild(0).GetChild(0).gameObject;
    }

    IEnumerator DelayedLockOverWrite()
    {
        yield return new WaitForSeconds(0.4f);
        linkedPortal.GetComponent<Rotator>().lockOverride = false;
    }
}
