using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIToggle
{
    public static bool IsOn(int InstanceIDGameObject, int InstanceIDComponent)
    {
        Toggle toggle = (Toggle)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return toggle.isOn;
    }

    public static void SetOn(int InstanceIDGameObject, int InstanceIDComponent, bool isOn)
    {
		Toggle toggle = (Toggle)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        toggle.isOn = isOn;
	}
}
