using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneControl : MonoBehaviour
{
    private string[] scenes = {"A","B","C"};
    private string thisScene;
    private int nextIndex;
    private int prevIndex;
    // Start is called before the first frame update
    void Start()
    {
        thisScene = SceneManager.GetActiveScene().name;
        for(int i = 0; i < scenes.Length; i++){
            if(scenes[i]==thisScene){
                nextIndex = i+1;
                nextIndex = (nextIndex==3)?0:nextIndex;
                prevIndex = i-1;
                prevIndex = (prevIndex==-1)?(scenes.Length-1):prevIndex;
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape)){
            Application.Quit();
        }
        if(Input.GetKeyDown(KeyCode.LeftArrow) || Input.GetKeyDown(KeyCode.A)){
            SceneManager.LoadScene(scenes[prevIndex], LoadSceneMode.Single);
        }
        if(Input.GetKeyDown(KeyCode.RightArrow) || Input.GetKeyDown(KeyCode.D)){
            SceneManager.LoadScene(scenes[nextIndex], LoadSceneMode.Single);
        }
    }
}
