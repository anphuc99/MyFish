using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
[MoonSharpUserData]
public class APIScreen
{
    public static float GetWidth()
    {
        return Screen.width;
    }

    public static float GetHeight() 
    { 
        return Screen.height;    
    }
}
