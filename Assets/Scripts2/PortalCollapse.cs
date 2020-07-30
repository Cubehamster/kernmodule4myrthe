using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCollapse : MonoBehaviour
{
    public GameObject[] portals;

    private float distancemultiplier = 1.0f;
    private bool startCollapse = false;
    private float timer = 0.0f;

    // Update is called once per frame
    void Update()
    {
        if (startCollapse && distancemultiplier >= 0.2f)
        {
            timer += Time.deltaTime;
            distancemultiplier = 1.0f - 0.1f * timer;
            for (int i = 0; i < portals.Length; i++)
            {
                portals[i].transform.position = new Vector3(portals[i].transform.position.x, portals[i].transform.position.y, distancemultiplier * portals[i].transform.position.z);
            }
        }
    }

    public void initiateCollapse()
    {
        startCollapse = true;
    }
}
