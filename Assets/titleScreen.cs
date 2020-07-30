using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class titleScreen : MonoBehaviour
{
    private GameObject DDOL;

    private void Start()
    {
        DDOL = GameObject.Find("__app");
    }

    // Start is called before the first frame update
    public void startGame()
    {
        DDOL.GetComponent<LevelManager>().level = 1;
        DDOL.GetComponent<LevelManager>().isLoaded = false;
    }
    public void QuitGame()
    {
        Application.Quit();
    }
}
