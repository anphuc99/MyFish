using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[MoonSharpUserData]
public class APIDataLocalManager
{
    public static void Save()
    {
        DataManager.Instance.Save();
    }

    public static void SetCache(string key, Table vaule)
    {
        DataManager.SetCache(key, vaule);
    }

    public static Table GetCache(string key)
    {        
        return DataManager.GetCache(key);
    }
}
