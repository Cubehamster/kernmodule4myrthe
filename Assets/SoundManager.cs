using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public bool transitioning = false;
    public LevelManager levelManager;
    public List<GameObject> BGM;
    public List<GameObject> BGMtransitions;
    FMOD.Studio.Bus Master;
    public float MasterVolume = 0.5f;

    private void Start()
    {
        Master = FMODUnity.RuntimeManager.GetBus("bus:/");
    }

    // Update is called once per frame
    void Update()
    {
        if (levelManager.level == 2)
        {
             StartCoroutine(SwitchAudio(BGM[1], BGMtransitions[0]));
        }
        if (levelManager.level == 3)
        {
            StartCoroutine(SwitchAudio(BGM[2], BGMtransitions[1]));
        }
        if (levelManager.level == 4)
        {
            StartCoroutine(SwitchAudio(BGM[3], BGMtransitions[2]));
        }
        Master.setVolume(MasterVolume);
    }

    IEnumerator SwitchAudio(GameObject newBGM, GameObject BGMtransition)
    {
        if (!newBGM.activeSelf && !transitioning)
        {
            transitioning = true;

            foreach (GameObject go in BGM)
            {
                go.SetActive(false);
            }
            BGMtransition.SetActive(true);
            if (levelManager.level == 1 || levelManager.level == 2)
                yield return new WaitForSeconds(8.0f);
            else
                yield return new WaitForSeconds(8.0f);
            newBGM.SetActive(true);
            BGMtransition.SetActive(false);
            transitioning = false;
        }

    }

    public void MasterVolumeLevel(float newMasterVolume)
    {
        MasterVolume = newMasterVolume * 2;
    }
}
