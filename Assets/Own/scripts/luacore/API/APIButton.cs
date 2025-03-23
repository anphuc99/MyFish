using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIButton
{
    public static void SetInteractable(bool interactable, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Button button = (Button)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        button.interactable = interactable;
    }

    public static bool GetInteractable(int InstanceIDGameObject, int InstanceIDComponent)
    {
        Button button = (Button)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return button.interactable;
    }
}
