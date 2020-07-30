using UnityEngine;
using System.Collections;

public class OnWillRenderObject2 : MonoBehaviour
{
    public Renderer rend;

    private float timePass = 0.0f;

    void Start()
    {
        rend = GetComponent<Renderer>();
    }

    private void Update()
    {
        print("test");
    }

    void OnWillRenderObject()
    {
        print(gameObject.name + " is being rendered by " + Camera.current.name + " at ");
        //timePass += Time.deltaTime;

        //if (timePass > 1.0f)
        //{
        //    timePass = 0.0f;
        //    print(gameObject.name + " is being rendered by " + Camera.current.name + " at " + Time.time);
        //}
    }
}
