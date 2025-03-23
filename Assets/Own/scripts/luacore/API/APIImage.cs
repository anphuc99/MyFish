using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIImage
{
    public static void SetSprite(int spriteID, int InstanceIDGameObject, int InstanceIDComponent)
    {
        if (LuaCore.Instance.luaSprite.ContainsKey(spriteID))
        {
            Image image = (Image)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
            image.sprite = LuaCore.Instance.luaSprite[spriteID];
        }
    }

    public static void SetColor(Table color, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Image image = (Image)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        image.color = LuaCore.Instance.ConverTableToColor(color);
    }

    public static Table GetColor(int InstanceIDGameObject, int InstanceIDComponent)
    {
        Image image = (Image)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return LuaCore.Instance.ConverColorToTable(image.color);
    }

    public static bool GetRaycastTarget(int InstanceIDGameObject, int InstanceIDComponent)
    {
        Image image = (Image)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return image.raycastTarget;
    }
}
