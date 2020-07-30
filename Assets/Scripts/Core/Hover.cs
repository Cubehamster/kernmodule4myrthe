using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hover : MonoBehaviour
{
    public float amplitude;
    public float speed;

    private float motionTime;
    private Vector3 startPosition;
    private Quaternion startRotation;
    private float timeOffset;

    private void Start()
    {
        startPosition = transform.localPosition;
        startRotation = transform.localRotation;
        timeOffset = Random.Range(0.0f, 200f);
    }    

    // Update is called once per frame
    void Update()
    {
        motionTime += Time.deltaTime * speed;
        transform.localPosition = startPosition + new Vector3(amplitude*Mathf.Sin(motionTime + timeOffset), amplitude*Mathf.Sin(1.1f * motionTime + timeOffset), amplitude*Mathf.Sin(0.7f * motionTime + timeOffset));
        transform.localRotation = startRotation * Quaternion.Euler(amplitude * Mathf.Sin(motionTime + timeOffset), amplitude * Mathf.Sin(1.1f * motionTime + timeOffset), amplitude * Mathf.Sin(0.7f * motionTime + timeOffset));
    }
}
