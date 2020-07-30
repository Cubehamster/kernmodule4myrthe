using UnityEngine;

public class Example : MonoBehaviour
{
    // Detects manually if obj is being seen by the main camera

    GameObject obj;
    Collider objCollider;

    Camera cam;
    Plane[] planes;



    void Update()
    {
        cam = Camera.main;
        planes = GeometryUtility.CalculateFrustumPlanes(cam);
        objCollider = GetComponent<Collider>();
        if (GeometryUtility.TestPlanesAABB(planes, objCollider.bounds))
        {
            Debug.Log(obj.name + " has been detected!");
        }
        else
        {
            Debug.Log("Nothing has been detected");
        }
    }
}