using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndPortal : MonoBehaviour
{
    public Vector3 winOrientation;
    public Transform FirstPersonController;
    public Transform Camera;
    private float alpha;
    private GameObject Lock;
    private LevelManager levelmanager;
    private bool HasEntered;
    private bool levelFinished = false;

    private void Start()
    {
        levelFinished = false;
        Lock = transform.GetChild(0).gameObject;
        levelmanager = GameObject.Find("__app").GetComponent<LevelManager>();

    }

    void LateUpdate()
    {
        if (Vector3.Dot(FirstPersonController.transform.up, winOrientation) > 0.9f)
        {
            alpha = Mathf.Lerp(alpha, 0f, 0.045f);
            transform.GetComponent<Renderer>().material.SetFloat("_Intensity", alpha);
            Lock.GetComponent<MeshCollider>().enabled = false;
        }
        else if (Vector3.Dot(FirstPersonController.transform.up, winOrientation) <= 0.9f)
        {
            alpha = Mathf.Lerp(alpha, 0.8f, 0.045f);
            transform.GetComponent<Renderer>().material.SetFloat("_Intensity", alpha);
            Lock.GetComponent<MeshCollider>().enabled = true;
        }

        if (HasEntered)
        {
            if (Vector3.Dot(Camera.position - transform.position - 0.2f * transform.up, transform.up) <= 0 && !levelFinished)
            {
                levelFinished = true;
                levelmanager.level += 1;
                levelmanager.isLoaded = false;
            }
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            HasEntered = true;

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            HasEntered = false;
        }
    }
}