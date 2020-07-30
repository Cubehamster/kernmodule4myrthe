using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WPortalCameraExperimental : MonoBehaviour
{
    public GameObject portalIn;
    public GameObject portalOut;
    public Transform cameraBody;

    private GameObject childPlayerMarkerOut;
    private GameObject player;
    private Transform playerCamera;
    private GameObject cameraOtherPortal;

    private void Start()
    {
        //Create a reference Marker
        childPlayerMarkerOut = new GameObject("childPlayerMarkerOut");
        childPlayerMarkerOut.transform.SetParent(portalIn.transform, true);

        //Find player Information
        player = GameObject.FindWithTag("Player");
        playerCamera = GameObject.FindWithTag("MainCamera").transform;

        portalIn.transform.SetAsFirstSibling();
        portalOut.transform.SetAsFirstSibling();
    }

    // Update is called once per frame
    void Update()
    {
        //Marker
        childPlayerMarkerOut.transform.position = player.transform.position;
        childPlayerMarkerOut.transform.rotation = player.transform.rotation;

        //BodyRotation
        Quaternion correction = Quaternion.Euler(childPlayerMarkerOut.transform.localEulerAngles);

        cameraBody.eulerAngles = portalOut.transform.eulerAngles;
        cameraBody.rotation = Quaternion.LookRotation(-portalOut.transform.forward, portalOut.transform.up) * correction;

        //Look Rotation
        float xlookAngle = playerCamera.localEulerAngles.x;
        transform.localRotation = Quaternion.Euler(xlookAngle, 0, 0);
        
        //Positioner
        Vector3 standardPlayerOffsetFromPortal = childPlayerMarkerOut.transform.localPosition;
        cameraBody.localPosition = new Vector3(-childPlayerMarkerOut.transform.localPosition.x, childPlayerMarkerOut.transform.localPosition.y, -childPlayerMarkerOut.transform.localPosition.z);

    }

}
