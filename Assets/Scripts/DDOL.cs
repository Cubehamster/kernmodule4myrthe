using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DDOL : MonoBehaviour
{
    public Texture2D cursorArrow;

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
        Cursor.visible = false;
        Cursor.SetCursor(cursorArrow, Vector2.zero, CursorMode.ForceSoftware);
    }

}
