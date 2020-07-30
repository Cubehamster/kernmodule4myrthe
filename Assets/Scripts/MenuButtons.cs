using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MenuButtons : MonoBehaviour {

    [SerializeField]LevelManager levelManager;
    FirstPersonAIO player;
    [SerializeField] Slider sensitivitySlider;
    [SerializeField] Slider volumeSlider;
    public SoundManager Audio;

    public float volume = 0.5f;

    public void Continue() {
        GameManager manager = GameObject.FindObjectsOfType<GameManager>()[0];
        manager.CloseMenu();
    }
    public void QuitGame()
    {
        Application.Quit();
    }

    public void Restart() {
        levelManager.isLoaded = false;
    }

    public void TitleScreen() {
        levelManager.level = 0;
        levelManager.isLoaded = false;
    }

    public void setSensitivity() {
        if (player == null) {
            player = GameObject.Find("FirstPerson-AIO").GetComponent<FirstPersonAIO>();
        }

        player.mouseSensitivity = sensitivitySlider.value + 1;
    }


    public void setVolume() {
        volume = volumeSlider.value;
        Audio.MasterVolume = volume;
    }
}