using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APISceneLoader
{
    public static void Load(string scene)
    {
        SceneLoader.Instance.LoadScene(scene);
    }

    public static void LoadData()
    {
        SceneLoader.Instance.LoadData();
    }

    public static void SetValue(float value)
    {
        SceneLoader.Instance.SetValue(value);
    }
}
