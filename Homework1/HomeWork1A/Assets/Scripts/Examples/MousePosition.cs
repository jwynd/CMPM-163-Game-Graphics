using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class MousePosition : MonoBehaviour
{
    Renderer render;

    // Start is called before the first frame update
    void Start()
    {
        render = GetComponent<Renderer>();

        //render.material.shader = Shader.Find("Custom/MouseInput");
    }

    // Update is called once per frame
    void Update()
    {
        render.material.SetFloat("_Mix", Input.mousePosition.x / Screen.width);
        render.material.SetInt("_LookUpDistance", (int)Math.Floor((Input.mousePosition.y / Screen.height) * 5.0f)+1);


        // Debug.Log(Input.mousePosition);
    }
}
