using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalPlacement : MonoBehaviour
{
    private Transform player;
    private Transform playerCamera;
    private Transform SunPortal;
    private Transform MoonPortal;
    private LayerMask raycastPortalCheckLayer;
    public GameObject PortalSoundEffect;

    private Transform TestMarker;
    [SerializeField] private Transform playerClone;
    private bool hasFloor = false;

    private void Awake()
    {
        player = GameObject.Find("FirstPerson-AIO").transform;
        playerCamera = GameObject.Find("Player Camera").transform;
        SunPortal = GameObject.Find("SunPortal").transform;
        MoonPortal = GameObject.Find("MoonPortal").transform;
        TestMarker = transform.GetChild(0);
    }

    // Update is called once per frame
    void Update()
    {
        GetClone();
        RaycastSurfaceCheck();
        PortalPlacer();
        
    }

    private void GetClone()
    {
        if (transform.childCount == 2)
        {
            if (transform.GetChild(1).name == "MoonPortal")
            {
                playerClone = SunPortal.GetComponent<Portal>().bodyCam;
            }
            else if (transform.GetChild(1).name == "SunPortal")
            {
                playerClone = MoonPortal.GetComponent<Portal>().bodyCam;
            }
        }
        else
        {
            //playerClone = null;
        }
    }

    private void PortalPlacer()
    {
        RaycastHit[] hits2;

        hits2 = Physics.RaycastAll(playerCamera.position, playerCamera.forward, 5F);

        for (int i = 0; i < hits2.Length; i++)
        {
            RaycastHit hit2 = hits2[i];
            if (hits2[i].transform.name == "TestSurface")
            {
                if (hits2[i].transform.parent.parent.childCount == 1 && Input.GetKey(KeyCode.Mouse0))
                {
                    PortalSoundEffect.SetActive(true);
                    SunPortal.GetComponent<Rotator>().scale = 0;
                    SunPortal.parent = transform;
                    SunPortal.GetComponent<Rotator>().alpha = 1;
                    SunPortal.localRotation = Quaternion.Euler(0, 0, 0);
                    SunPortal.localPosition = new Vector3(0, 0, 0.0f);
                    
                }
                if (hits2[i].transform.parent.parent.childCount == 1 && Input.GetKey(KeyCode.Mouse1))
                {
                    PortalSoundEffect.SetActive(true);
                    MoonPortal.GetComponent<Rotator>().scale = 0;
                    MoonPortal.parent = transform;
                    MoonPortal.GetComponent<Rotator>().alpha = 1;
                    MoonPortal.localRotation = Quaternion.Euler(0, 180, 0);
                    MoonPortal.localPosition = new Vector3(0, 0, 0f);
                    
                }
                if(Input.GetKeyUp(KeyCode.Mouse0) || Input.GetKeyUp(KeyCode.Mouse1))
                    PortalSoundEffect.SetActive(false);
            }
        }
    }

    private void RaycastSurfaceCheck()
    {
        if (transform.childCount == 2 && playerClone != null)
        {

            RaycastHit[] hits;

            if (transform.GetChild(1).name == "MoonPortal")
            {
                Debug.DrawLine(TestMarker.position, TestMarker.position - playerClone.transform.up * 5f, Color.red);
                hits = Physics.RaycastAll(TestMarker.position, -playerClone.transform.up, 4F);
                SunPortal.GetComponent<Rotator>().hasFloor = false;
                for (int i = 0; i < hits.Length; i++)
                {
                    RaycastHit hit = hits[i];
                    if (hits[i].transform.tag == "LevelParts" && transform.GetChild(1).name == "MoonPortal")
                    {
                        SunPortal.GetComponent<Rotator>().hasFloor = true;
                    }
                    else if (hits[i].transform.tag == "LevelParts" && transform.GetChild(1).name == "SunPortal")
                    {
                        MoonPortal.GetComponent<Rotator>().hasFloor = true;
                    }

                }
            }
            else if (transform.GetChild(1).name == "SunPortal")
            {
                Debug.DrawLine(TestMarker.position, TestMarker.position - playerClone.transform.up * 4f, Color.cyan);
                hits = Physics.RaycastAll(TestMarker.position, -playerClone.transform.up, 4F);
                MoonPortal.GetComponent<Rotator>().hasFloor = false;
                for (int i = 0; i < hits.Length; i++)
                {
                    RaycastHit hit = hits[i];
                    if (hits[i].transform.tag == "LevelParts" && transform.GetChild(1).name == "MoonPortal")
                    {
                        SunPortal.GetComponent<Rotator>().hasFloor = true;
                    }
                    else if (hits[i].transform.tag == "LevelParts" && transform.GetChild(1).name == "SunPortal")
                    {
                        MoonPortal.GetComponent<Rotator>().hasFloor = true;
                    }

                }
            }

            //if (!hasFloor && transform.GetChild(1).name == "SunPortal")
            //{
            //    Debug.Log("Moon Is locked");
            //    MoonPortal.GetComponent<Rotator>().hasFloor = false;
            //}
            //else if(hasFloor && transform.GetChild(1).name == "SunPortal")
            //{
            //    Debug.Log("Moon Is unlocked");
            //    MoonPortal.GetComponent<Rotator>().hasFloor = true;
            //}

            //if (!hasFloor && transform.GetChild(1).name == "MoonPortal")
            //{
            //    Debug.Log("Sun Is locked");
            //    SunPortal.GetComponent<Rotator>().hasFloor = false;
            //}
            //else if (hasFloor && transform.GetChild(1).name == "MoonPortal")
            //{
            //    Debug.Log("Sun Is unlocked");
            //    SunPortal.GetComponent<Rotator>().hasFloor = true;
            //}

        }
    }
}
