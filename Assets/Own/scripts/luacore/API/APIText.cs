using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIText
{
    public static void SetText(string text, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Text txt = (Text)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.text = text;
    }
}
