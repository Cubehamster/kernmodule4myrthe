using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMOD;

public class SmoothLightRotator : MonoBehaviour
{
    public Transform DirectionalRef;
    public float rotationAcceleration = 10f;
    public float maxRotationSpeed = 100.0f;

    void Start()
    {
        DirectionalRef.rotation = transform.rotation;
    }
        // Update is called once per frame
        void Update()
    {
        Vector3 targetRotation = DirectionalRef.rotation.eulerAngles;

        Vector3 eulerAngles = transform.rotation.eulerAngles;

        Vector3 rotationVelocity = Vector3.zero;

        eulerAngles.x = Mathf.SmoothDampAngle(eulerAngles.x, targetRotation.x, ref rotationVelocity.x, rotationAcceleration, maxRotationSpeed);
        eulerAngles.y = Mathf.SmoothDampAngle(eulerAngles.y, targetRotation.y, ref rotationVelocity.y, rotationAcceleration, maxRotationSpeed);
        eulerAngles.z = Mathf.SmoothDampAngle(eulerAngles.z, targetRotation.z, ref rotationVelocity.z, rotationAcceleration, maxRotationSpeed);

        transform.rotation = Quaternion.Euler(eulerAngles);

        
    }

}
