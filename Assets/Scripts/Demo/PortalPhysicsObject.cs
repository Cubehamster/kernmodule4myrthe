using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent (typeof (Rigidbody))]
public class PortalPhysicsObject : PortalTraveller {

    new Rigidbody rigidbody;
    public Color[] colors;
    static int i;
    public Material moonMat;
    public Material sunMat;

    void Awake () {
        rigidbody = GetComponent<Rigidbody> ();  
    }

    private void Update()
    {
        //if(transform.childCount == 2)
        //{
        //    if (gameObject.layer == 11 && transform.GetChild(1) != null)
        //    {
        //        transform.GetChild(1).GetComponent<Renderer>().material = moonMat;
        //    }
        //    else if (transform.GetChild(1) != null)
        //    {
        //        transform.GetChild(0).GetComponent<Renderer>().material = sunMat;
        //    }
        //}
    }

    public override void Teleport(Transform fromPortal, Transform toPortal, Vector3 pos, Quaternion rot)
    {
        base.Teleport(fromPortal, toPortal, pos, rot);
        rigidbody.velocity = toPortal.TransformVector(fromPortal.InverseTransformVector(rigidbody.velocity));
        rigidbody.angularVelocity = toPortal.TransformVector(fromPortal.InverseTransformVector(rigidbody.angularVelocity));
    }
}