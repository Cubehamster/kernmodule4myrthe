using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewFrustrum : MonoBehaviour
{
    public Camera playerCamera;
    private LightProbeGroup lightProbeGroup;
    private Vector3 size = new Vector3(14.2f, 14.2f, 14.2f);

    private void Start()
    {
        LightProbeGroup lightProbeGroup = GetComponent<LightProbeGroup>();
    }

    void Update()
    {
      

        if (IsVisible(playerCamera))
        {
            Debug.Log("is detected");
        }
        else
        {
            Debug.Log("is not detected");
        }

    }

    bool IsVisible(Camera camera)
    {
        var bounds = GeometryUtility.CalculateBounds(lightProbeGroup.probePositions, transform.localToWorldMatrix);
        var planes = GeometryUtility.CalculateFrustumPlanes(camera);
        return (GeometryUtility.TestPlanesAABB(planes, bounds));
    }
}
