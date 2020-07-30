using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class matLoc : MonoBehaviour
{
    public Vector3 mypos;
    Material m_Material;
    private void Start()
    {
        m_Material = GetComponent<Renderer>().material;
        Vector3 mypos = transform.position;

        mypos = transform.position;
        m_Material.SetVector("_Location", mypos);
    }
    void Update()
    {
        mypos = transform.position;
        m_Material.SetVector("_Location", mypos);
    }
}
