using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

[MoonSharpUserData]
public class APITMP_InputField
{
    public static string GetText(int InstanceIDGameObject, int InstanceIDComponent)
    {
        TMP_InputField txt = (TMP_InputField)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return txt.text;
    }

    public static void SetText(string text, int InstanceIDGameObject, int InstanceIDComponent)
    {
        TMP_InputField txt = (TMP_InputField)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.text = text;
    }
}
