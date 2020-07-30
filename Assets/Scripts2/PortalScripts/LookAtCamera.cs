using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtCamera : MonoBehaviour
{
    public GameObject PlayerCamera;

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(PlayerCamera.transform);
    }
}
