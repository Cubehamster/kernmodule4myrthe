using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerController : MonoBehaviour
{
    public GameObject Camera;
    Rigidbody rb;
    public float movementSpeed;
    public float rotSpeed = 2.0f;
    private float yRot = 0.0f;
    private float xRot = 0.0f;
    public Vector3 defaultRotation;
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        defaultRotation = transform.rotation.eulerAngles;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        xRot += rotSpeed * -Input.GetAxis("Mouse Y");
        yRot += rotSpeed * Input.GetAxis("Mouse X");
        transform.eulerAngles = (defaultRotation + new Vector3(0.0f, yRot, 0.0f));
        Camera.transform.localEulerAngles = new Vector3(xRot, 0.0f, 0.0f);

        transform.Translate(transform.forward * Input.GetAxis("Vertical") * movementSpeed);
        transform.Translate(transform.right * Input.GetAxis("Horizontal") * movementSpeed);
    }
}
