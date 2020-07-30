using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldToViewPoint : MonoBehaviour
{
    public GameObject test;

    // Disable the behaviour when it becomes invisible...
    void OnBecameInvisible()
    {
        test.SetActive(false);
    }

    // ...and enable it again when it becomes visible.
    void OnBecameVisible()
    {
        test.SetActive(true);
    }
}

