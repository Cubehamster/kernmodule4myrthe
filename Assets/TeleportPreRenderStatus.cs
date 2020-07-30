using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportPreRenderStatus : MonoBehaviour
{
    public bool hasTeleported = false;

    private void Update()
    {
        if (hasTeleported)
        {
            hasTeleported = false;
        }
    }
}
