using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SideChecker : MonoBehaviour
{
    public Transform Player;
    public Transform Portal;


    // Update is called once per frame
    void Update()
    {
        Debug.Log(Vector3.Dot(Player.position - Portal.position, Portal.up));
    }
}
