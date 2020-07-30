using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sunRotate : MonoBehaviour
{
    public int speed;
    private float number;
    // Update is called once per frame
    private void Start()
    {
        number = transform.eulerAngles.z;
    }
    void Update()
    {
        number += speed * Time.deltaTime;
        transform.rotation = Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, number);
        

    }
}