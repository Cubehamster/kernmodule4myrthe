using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCamDelayed : MonoBehaviour
{
    public Transform portalCam;
    public Transform playerCam;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void LateUpdate()
    {
        GetComponent<Skybox>().material = playerCam.GetComponent<Skybox>().material;
    }

    void Render()
    {
        GetComponent<Skybox>().material = playerCam.GetComponent<Skybox>().material;
    }
}
