using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIInputField
{
    public static string GetText(int InstanceIDGameObject, int InstanceIDComponent)
    {
        InputField txt = (InputField)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return txt.text;
    }

    public static void SetText(string text, int InstanceIDGameObject, int InstanceIDComponent)
    {
        InputField txt = (InputField)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.text = text;
    }
}
