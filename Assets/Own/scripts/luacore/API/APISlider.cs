using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APISlider
{
    public static float GetValue(int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return slider.value;
    }
    public static void SetValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        slider.value = value;
    }

    public static void SetMinValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        slider.minValue = value;
    }

    public static void SetMaxValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        slider.maxValue = value;
    }

    public static void SmoothValue(int InstanceIDGameObject, int InstanceIDComponent, float toValue, float time, int leanTweenType, DynValue callback)
    {
        Slider slider = (Slider)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        LeanTween.value(slider.gameObject, slider.value, toValue, time).setEase((LeanTweenType)leanTweenType).setOnUpdate((float value) =>
        {
            slider.value = value;
        }).setOnComplete(() =>
        {
            if (callback.Type == DataType.Function)
            {
                callback.Function.CallFunction();
            }
        });
    }
}
