using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CopyCameraSettings : MonoBehaviour
{
    public Camera ARCamera;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        GetComponent<Camera>().fieldOfView = ARCamera.fieldOfView;
        GetComponent<Camera>().nearClipPlane = ARCamera.nearClipPlane;
        GetComponent<Camera>().farClipPlane = ARCamera.farClipPlane;
    }
}
