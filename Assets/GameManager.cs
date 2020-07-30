using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    private GameObject DDOL;
    private Animator FadeOutAnimator;
    private GameObject Menu;

    private bool levelComplete;
    private bool endSequence;
    [SerializeField] private GameObject FirstPersonController;

    public List<GameObject> DagStates;
    public GameObject MoonLight;
    public GameObject SunLight;
    private int dagState;

    // Start is called before the first frame update
    void Start()
    {
        DDOL = GameObject.Find("__app");
        Menu = DDOL.transform.GetChild(0).GetChild(0).gameObject;
        if (DDOL.GetComponents<LevelManager>()[0].level == 0)
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }
        else
        {
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
            FirstPersonController = GameObject.Find("FirstPerson-AIO");
            FirstPersonController.GetComponent<FirstPersonAIO>().enableCameraMovement = true;
        }
        Menu.SetActive(false);

        Time.timeScale = 1f;
        FadeOutAnimator = DDOL.GetComponentInChildren<Animator>();
        FadeOutAnimator.gameObject.SetActive(false);
        FadeOutAnimator.gameObject.SetActive(true);
        FadeOutAnimator.SetBool("FadeOut", false);

        foreach (GameObject go in DagStates)
            go.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        BringUpMenu();
        DagStateChanger();
    }

    IEnumerator LevelComplete()
    {
        yield return new WaitForSeconds(5f);
        if (!endSequence)
        {
            endSequence = true;
            Cursor.visible = false;
            FadeOut();
            yield return new WaitForSeconds(1f);
            DDOL.GetComponents<LevelManager>()[0].level += 1;
            DDOL.GetComponents<LevelManager>()[0].isLoaded = false;
            Time.timeScale = 1f;

        }
    }

    private void FadeOut()
    {
        FadeOutAnimator.SetBool("FadeOut", true);
    }

    private void BringUpMenu()
    {
        if (Input.GetKeyDown(KeyCode.Escape) && !Menu.activeSelf && DDOL.GetComponents<LevelManager>()[0].level != 0)
        {
            Cursor.visible = true;
            Menu.SetActive(true);
            Time.timeScale = 0f;
            Cursor.lockState = CursorLockMode.None;
            FirstPersonController.GetComponent<FirstPersonAIO>().enableCameraMovement = false;
        }
        else if (Input.GetKeyDown(KeyCode.Escape) && Menu.activeSelf && DDOL.GetComponents<LevelManager>()[0].level != 0)
        {
            Cursor.visible = false;
            Menu.SetActive(false);
            Time.timeScale = 1f;
            Cursor.lockState = CursorLockMode.Locked;
            FirstPersonController.GetComponent<FirstPersonAIO>().enableCameraMovement = true;
        }
    }

    public void CloseMenu() {
        if (Menu.activeSelf && DDOL.GetComponents<LevelManager>()[0].level != 0) {
            Cursor.visible = false;
            Menu.SetActive(false);
            Time.timeScale = 1f;
            Cursor.lockState = CursorLockMode.Locked;
            FirstPersonController.GetComponent<FirstPersonAIO>().enableCameraMovement = true;
        }
    }

    private void LevelProgressTracker()
    {
        if (levelComplete)
        {
            StartCoroutine(LevelComplete());
        }

    }

    private void DagStateChanger()
    {
        if (DDOL.GetComponents<LevelManager>()[0].level != 0 && FirstPersonController != null)
        {
            if (FirstPersonController.layer == 11)
            {
                if (dagState >= 2)
                {
                    dagState = 0;
                    foreach (GameObject go in DagStates)
                        go.SetActive(false);
                    DagStates[0].SetActive(true);
                }
                if (dagState != 0 && Vector3.Dot(SunLight.transform.forward.normalized, -Vector3.up) >= 0.1f)
                {
                    dagState = 0;
                    foreach (GameObject go in DagStates)
                        go.SetActive(false);
                    DagStates[0].SetActive(true);
                }
                else if (dagState != 1 && Vector3.Dot(SunLight.transform.forward.normalized, -Vector3.up) < -0.1f)
                {
                    dagState = 1;
                    foreach (GameObject go in DagStates)
                        go.SetActive(false);
                    DagStates[1].SetActive(true);
                }
            }
            else if (FirstPersonController.layer == 12 && FirstPersonController != null)
            {
                if (dagState < 2)
                {
                    dagState = 2;
                    foreach (GameObject go in DagStates)
                        go.SetActive(false);
                    DagStates[2].SetActive(true);
                }
                if (dagState != 2 && Vector3.Dot(MoonLight.transform.forward.normalized, -Vector3.up) >= 0.1f)
                {
                    dagState = 2;
                    foreach (GameObject go in DagStates)
                        go.SetActive(false);
                    DagStates[2].SetActive(true);
                }
                else if (dagState != 3 && Vector3.Dot(MoonLight.transform.forward.normalized, -Vector3.up) < -0.1f)
                {
                    dagState = 3;
                    foreach (GameObject go in DagStates)
                        go.SetActive(false);
                    DagStates[3].SetActive(true);
                }
            }
        }
     
    }
}
