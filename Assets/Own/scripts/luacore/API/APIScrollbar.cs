using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIScrollbar
{
    public static void SetValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Scrollbar scrollbar = (Scrollbar)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        scrollbar.value = value;
    }

    public static void SmoothValue(int InstanceIDGameObject, int InstanceIDComponent, float toValue, float time, int leanTweenType, DynValue callback)
    {
        Scrollbar scrollbar = (Scrollbar)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        LeanTween.value(scrollbar.gameObject, scrollbar.value, toValue, time).setEase((LeanTweenType)leanTweenType).setOnUpdate((float value) =>
        {
            scrollbar.value = value;
        }).setOnComplete(() =>
        {
            if (callback.Type == DataType.Function)
            {
                callback.Function.CallFunction();
            }
        });
    }
}
