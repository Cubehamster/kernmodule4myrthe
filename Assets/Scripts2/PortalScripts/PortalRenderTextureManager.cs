using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalRenderTextureManager : MonoBehaviour
{
    public Camera cameraLayer;

    public Material cameraMatLayer;
    public Material fakeMat;

    // Start is called before the first frame update
    void Update()
    {
        if (cameraLayer.targetTexture != null)
        {
            cameraLayer.targetTexture.Release();
        }

        //RenderTexture tempRTB = RenderTexture.GetTemporary(Screen.width, Screen.height, 4, RenderTextureFormat.ARGB64);
        //cameraMatYLayer0.mainTexture = tempRTB;
        //RenderTexture.ReleaseTemporary(tempRTB);

        cameraLayer.targetTexture = new RenderTexture(Screen.width, Screen.height, 4, RenderTextureFormat.ARGB64);
        cameraMatLayer.mainTexture = cameraLayer.targetTexture;
        fakeMat.mainTexture = cameraLayer.targetTexture;
        cameraLayer.targetTexture.Release();

        //    if (cameraYLayer1.targetTexture != null)
        //     {
        //         cameraYLayer1.targetTexture.Release();
        //     }
        //     cameraYLayer1.targetTexture = new RenderTexture(Screen.width, Screen.height, 48, RenderTextureFormat.ARGBHalf);
        //     cameraMatYLayer1.mainTexture = cameraYLayer1.targetTexture;

        //RenderTexture tempRTY = RenderTexture.GetTemporary(Screen.width, Screen.height, 4, RenderTextureFormat.ARGB64);
        //cameraMatBLayer0.mainTexture = tempRTY;
        //RenderTexture.ReleaseTemporary(tempRTY);


        //     if (cameraBLayer1.targetTexture != null)
        //     {
        //          cameraBLayer1.targetTexture.Release();
        //     }
        //      cameraBLayer1.targetTexture = new RenderTexture(Screen.width, Screen.height, 48, RenderTextureFormat.ARGBHalf);
        //       cameraMatBLayer1.mainTexture = cameraBLayer1.targetTexture;
    }



}
