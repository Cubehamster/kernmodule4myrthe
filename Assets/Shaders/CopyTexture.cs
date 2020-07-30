using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CopyTexture : MonoBehaviour
{
    public Material InputMaterial;
    public Material FakeObject;

    private Texture Fake;


    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Fake = InputMaterial.mainTexture;
        FakeObject.SetTexture("_MainTex", Fake);
    }
}
