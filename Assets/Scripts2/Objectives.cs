using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Objectives : MonoBehaviour
{
    [SerializeField] private Text objectivesText;
    public int currentObjective = 0;

    private void Start()
    {
        NewObjective(1);
    }

    public void NewObjective(int number)
    {
        currentObjective = number;

        switch (currentObjective)
        {
            case 1:
                objectivesText.text = "Explore the Euclo";
                break;
            case 2:
                objectivesText.text = "Find a way to the artifact";
                break;
            case 3:
                objectivesText.text = "Get the artifact";
                break;
            case 4:
                objectivesText.text = "Find a way out";
                break;
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Tab))
        {
            objectivesText.gameObject.SetActive(true);
        }

        if (Input.GetKeyUp(KeyCode.Tab))
        {
            objectivesText.gameObject.SetActive(false);
        }
    }
}
