using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class Tutorial : MonoBehaviour
{
    public GameObject TutorialRotate1;
    public GameObject TutorialRotate2;

    public Transform MoonPortal;
    public Transform SunPortal;

    private Vector3 MoonPos;
    private Vector3 SunPos;

    public float alpha = 0;
    public float targetAlpha = 0;

    public Material MouseRotateMat;

    private bool TutorialDone = false;

    // Start is called before the first frame update
    void Start()
    {
        SunPos = SunPortal.position;
        MoonPos = MoonPortal.position;
        TutorialDone = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (!TutorialDone)
        {
            if (MoonPortal.position != MoonPos && SunPortal.position != SunPos)
            {
                targetAlpha = 1;
                TutorialRotate2.SetActive(true);
                TutorialRotate1.SetActive(true);
                if(MoonPortal.localEulerAngles.z != 0 || SunPortal.localEulerAngles.z != 0)
                {
                    TutorialDone = true;
                    targetAlpha = 0;
                }
            }
        }
        alpha = Mathf.Lerp(alpha, targetAlpha, 0.1f);
        MouseRotateMat.SetVector("_Color", new Vector4(1, 1, 1, alpha));
    }



}
