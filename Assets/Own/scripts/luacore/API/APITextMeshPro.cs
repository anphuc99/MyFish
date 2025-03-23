using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

[MoonSharpUserData]
public class APITextMeshPro
{
    public static void SetText(string text, int InstanceIDGameObject, int InstanceIDComponent)
    {
        TextMeshPro txt = (TextMeshPro)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.text = text;
    }

    public static void SetColor(Table color, int InstanceIDGameObject, int InstanceIDComponent)
    {
        TextMeshPro txt = (TextMeshPro)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.color = LuaCore.Instance.ConverTableToColor(color);
    }
}
