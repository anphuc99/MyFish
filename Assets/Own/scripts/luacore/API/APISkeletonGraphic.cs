using MoonSharp.Interpreter;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APISkeletonGraphic
{
    public static void SetColor(int InstanceIDGameObject, int InstanceIDComponent, Table tcolor)
    {
        SkeletonGraphic skeletonGraphic = (SkeletonGraphic)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        Color color = LuaCore.Instance.ConverTableToColor(tcolor);
        skeletonGraphic.color = color;
    }

    public static Table GetColor(int InstanceIDGameObject, int InstanceIDComponent)
    {
        SkeletonGraphic skeletonGraphic = (SkeletonGraphic)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return LuaCore.Instance.ConverColorToTable(skeletonGraphic.color);
    }
}
