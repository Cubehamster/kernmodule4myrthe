using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Work in Progress

public class PortalItemTeleporter : MonoBehaviour
{
    public Transform portalOut;
    public Transform item;
    public Transform TeleportLocation;
    public Transform TeleportMarker;

    private bool ItemIsOverlapping = false;
    
    void OnTriggerEnter(Collider item)
    {
        if (item.tag == "Item")
        {
            ItemIsOverlapping = true;
            Vector3 itemToPortal = item.transform.position - transform.position;
            float dotProduct = Vector3.Dot(transform.up, itemToPortal);

            Debug.Log("test");
        }
    }

    void OnTriggerExit(Collider item)
    {
        if (item.tag == "Item")
        {
            ItemIsOverlapping = false;
        }
    }
}
