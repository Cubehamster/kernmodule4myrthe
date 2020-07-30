//Written by Marnix Licht - Last Updated 21/05/19

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalPlayerTeleporter : MonoBehaviour
{
    public GameObject PortalOut;

    private GameObject PortalIn;
    private GameObject player;
    private GameObject playerCamera;
    private Camera cam;
    private Transform bodyCam;
    private Transform bodyCamToTurnOff;
    private Quaternion portalDifference;
    private GameObject velocityMarker;
    private Vector3 velocityOut;

    private bool doCalculation = false;
    private bool playerIsOverlapping = false;

    void Start()
    {
        //Find some game objects
        player = GameObject.FindWithTag("Player");
        playerCamera = GameObject.FindWithTag("MainCamera");
        cam = playerCamera.GetComponent<Camera>();
        bodyCam = PortalOut.transform.Find("CamBodyOther Layer 0").transform;
        PortalIn = transform.parent.gameObject;

        //calculates the ridigbody velocity angle change
        float portalAngleDifference = Vector3.Angle(PortalIn.transform.forward, PortalOut.transform.forward);
        portalDifference = Quaternion.AngleAxis(-portalAngleDifference, Vector3.Cross(PortalIn.transform.forward, PortalOut.transform.forward));

        //Create velocity Marker
        velocityMarker = new GameObject("velocityMarker");

    }

    // Update is called once per frame
    void Update()
    {  
        if (playerIsOverlapping)
        {
            Vector3 portalToPlayer = playerCamera.transform.position - transform.position;
            float dotProduct = Vector3.Dot(transform.up, portalToPlayer);
            //bodyCam.gameObject.SetActive(true);

            // If this is true: The player has moved across the portal
            if (dotProduct < 0)
            {
                //Get rotation
                Quaternion rotation = Quaternion.Euler(bodyCam.eulerAngles);                

                //Teleport velocity
                velocityMarker.transform.SetParent(PortalIn.transform);
                velocityMarker.transform.position = PortalIn.transform.position + player.GetComponent<Rigidbody>().velocity;
                Vector3 localVelocityIn = velocityMarker.transform.localPosition;
                velocityMarker.transform.SetParent(PortalOut.transform);
                velocityMarker.transform.localPosition = new Vector3 (-localVelocityIn.x, localVelocityIn.y, -localVelocityIn.z);
                Vector3 velocityOut = velocityMarker.transform.position - PortalOut.transform.position;
                //player.GetComponent<Rigidbody>().velocity = velocityOut;
                
                //Teleport him!
                player.GetComponent<FirstPersonAIO>().portalRotation(rotation, velocityOut);
                player.transform.position = bodyCam.position;

                playerIsOverlapping = false;

                Debug.Log("teleported");

            }
        }
    }    

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "MainCamera")
        {
            playerIsOverlapping = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "MainCamera")
        {
            playerIsOverlapping = false;
        }
    } 
}
