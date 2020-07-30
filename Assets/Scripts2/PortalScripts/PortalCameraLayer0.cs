//Written by Marnix Licht - Last Updated 21/05/19

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCameraLayer0 : MonoBehaviour
{
    public GameObject portalIn;
    public GameObject portalOut;

    private Transform cameraBody;
    private Transform camHeadJoint;
    private GameObject childPlayerMarkerOut;
    private GameObject player;
    private GameObject headJoint;
    private Transform playerCamera;

    private void Start()
    {
        //Create a reference Marker
        childPlayerMarkerOut = new GameObject("childPlayerMarkerOut");
        childPlayerMarkerOut.transform.SetParent(portalIn.transform, true);

        //Find player Information
        player = GameObject.FindWithTag("Player");
        headJoint = GameObject.FindWithTag("HeadJoint");
        playerCamera = GameObject.FindWithTag("MainCamera").transform;

        cameraBody = transform.parent.transform.parent.gameObject.transform;
        camHeadJoint = transform.parent.gameObject.transform;

    }

    // Update is called once per frame
    void LateUpdate()
    {
        //Marker
        childPlayerMarkerOut.transform.position = player.transform.position;
        childPlayerMarkerOut.transform.rotation = player.transform.rotation;
       

        //BodyRotation
        Quaternion correction = Quaternion.Euler(childPlayerMarkerOut.transform.localEulerAngles);

        cameraBody.eulerAngles = portalOut.transform.eulerAngles;
        cameraBody.rotation = Quaternion.LookRotation(-portalOut.transform.forward, portalOut.transform.up) * correction;

        //HeadJoint
        camHeadJoint.localPosition = headJoint.transform.localPosition;
        camHeadJoint.localEulerAngles = headJoint.transform.localEulerAngles;

        //Look Rotation
        float xlookAngle = playerCamera.localEulerAngles.x;
        transform.localRotation = Quaternion.Euler(xlookAngle, 0, 0);

        //Positioner
        Vector3 standardPlayerOffsetFromPortal = childPlayerMarkerOut.transform.localPosition;
        cameraBody.localPosition = new Vector3(-childPlayerMarkerOut.transform.localPosition.x, childPlayerMarkerOut.transform.localPosition.y, -childPlayerMarkerOut.transform.localPosition.z);

    }

}
