using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetPortals : MonoBehaviour
{
    public List<Transform> portalMarkers;
    public List<Transform> PortalFrames;
    public GameObject PortalMarkerPrefab;
    public GameObject MoonPortal;
    public GameObject SunPortal;

    private void Start()
    {
        foreach (Transform portal in PortalFrames)
        {
            GameObject marker = Instantiate(PortalMarkerPrefab, portal);
            marker.transform.localRotation = Quaternion.Euler(0, 90, 0);
            marker.transform.localPosition = new Vector3(0, 0, 0);
            marker.transform.parent = transform;
            portalMarkers.Add(marker.transform);
        }

        //MoonPortal.transform.position = PortalFrames[3].transform.position;
        //MoonPortal.transform.rotation = Quaternion.LookRotation(-PortalFrames[3].transform.right);
        //MoonPortal.transform.parent = portalMarkers[3];

        //SunPortal.transform.position = PortalFrames[4].transform.position;
        //SunPortal.transform.rotation = Quaternion.LookRotation(PortalFrames[4].transform.right);
        //SunPortal.transform.parent = portalMarkers[4];

    }
}
