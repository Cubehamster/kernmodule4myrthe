using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetVertexPos : MonoBehaviour
{
    [SerializeField] private Vector3[] vertices;
    [SerializeField] private List<Vector3> worldpt;
    [SerializeField] private List<Vector2> screenPos;
    public Camera cam;
    public GameObject quad;

    public Material InputMaterial;
    public Material FakeObject;

    public GameObject Background;
    public Texture Fake;

    private void Start()
    {


        Mesh mesh = quad.GetComponent<MeshFilter>().mesh;
        vertices = mesh.vertices;
        foreach (Vector3 vertex in vertices)
        {
            screenPos.Add(vertex);
            worldpt.Add(vertex);
        }

    }

    void Update()
    {
        Mesh mesh = quad.GetComponent<MeshFilter>().mesh;
        vertices = mesh.vertices;



        for (int i = 0; i < vertices.Length; i++)
        {
            worldpt[i] = quad.transform.TransformPoint(vertices[i]);
        }
        for (var i = 0; i < vertices.Length; i++)
        {
            screenPos[i] = new Vector2(cam.WorldToScreenPoint(worldpt[i]).x/cam.scaledPixelWidth, cam.WorldToScreenPoint(worldpt[i]).y/cam.scaledPixelHeight);
        }

        //Debug.Log(cam.scaledPixelWidth);
        //Debug.Log(cam.pixelWidth);
        //Debug.Log(Background.transform.localScale.x);

        //Debug.Log(cam.scaledPixelHeight);
       // Debug.Log(cam.pixelHeight);
       // Debug.Log(Background.transform.localScale.z);

        mesh.vertices = vertices;


        //FakeObject.SetFloat("_bottomleftXInput", screenPos[0].x);
        //FakeObject.SetFloat("_bottomleftYInput", screenPos[0].y);
        //FakeObject.SetFloat("_bottomrightXInput", -1 + screenPos[1].x);
        //FakeObject.SetFloat("_bottomrightYInput", screenPos[1].y);
        //FakeObject.SetFloat("_topleftXInput", screenPos[2].x);
        //FakeObject.SetFloat("_topleftYInput", -1 + screenPos[2].y);
        //FakeObject.SetFloat("_toprightXInput", -1 + screenPos[3].x);
        //FakeObject.SetFloat("_toprightYInput", -1 + screenPos[3].y);


        Fake = InputMaterial.GetTexture("_MainTex");
        FakeObject.SetTexture("_MainTex", Fake);
        Debug.Log(Fake);
    }
}