using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationCopier : MonoBehaviour
{
    private Animator modelController;
    [SerializeField] private GameObject Model;

    private void Start()
    {
        modelController = Model.GetComponent<Animator>();
        Model = transform.parent.GetChild(1).gameObject;
    }

    // Update is called once per frame
    void Update()
    {
        if(transform.name == "Model(Clone)")
        {
            
        }
    }
}
