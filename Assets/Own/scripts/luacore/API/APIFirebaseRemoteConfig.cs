using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[MoonSharpUserData]
public class APIFirebaseRemoteConfig
{
    public static string GetValue(string key)
    {
        return RemoteConfigManager.GetValue(key);
    }

    public static void SetDefaultValue(string key, string value)
    {
        RemoteConfigManager.SetDefaultData(key, value);
    }
}
