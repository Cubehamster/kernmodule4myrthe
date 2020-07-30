using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour
{
    public int level;
    [HideInInspector] public bool isLoaded;

    private void Awake()
    {
        isLoaded = false;
    }

    private void Update()
    {
        if(level == 0 && !isLoaded)
        {
            isLoaded = true;
            UnityEngine.SceneManagement.SceneManager.LoadScene("level0");
        }
        else if (level == 1 && !isLoaded)
        {
            isLoaded = true;
            UnityEngine.SceneManagement.SceneManager.LoadScene("level1");
        }
        else if (level == 2 && !isLoaded)
        {
            isLoaded = true;
            UnityEngine.SceneManagement.SceneManager.LoadScene("level2");
        }
        else if (level == 3 && !isLoaded)
        {
            isLoaded = true;
            UnityEngine.SceneManagement.SceneManager.LoadScene("level3");
        }
        else if (level == 4 && !isLoaded)
        {
            isLoaded = true;
            UnityEngine.SceneManagement.SceneManager.LoadScene("level4");
        }


    }


}
