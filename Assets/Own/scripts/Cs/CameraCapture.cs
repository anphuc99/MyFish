#if UNITY_EDITOR
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class CameraCapture : MonoBehaviour
{
    void Update()
    {
        // Change the key binding here, default is 'P'
        if (Input.GetKeyDown(KeyCode.Space))
        {
            TakeScreenshot();
        }
    }

    void TakeScreenshot()
    {
        // Construct the filename
        string filename =Path.Combine(Application.persistentDataPath, $"capture-{DateTimeOffset.UtcNow.ToUnixTimeSeconds()}.png");        
        // Take the screenshot
        ScreenCapture.CaptureScreenshot(filename);
        // Log the screenshot path to the console
        Debug.Log($"Screenshot saved to: {filename}");
    }
}
#endif