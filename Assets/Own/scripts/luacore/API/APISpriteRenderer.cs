using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APISpriteRenderer
{
    public static void SetSprite(int spriteID, int InstanceIDGameObject, int InstanceIDComponent)
    {
        if (LuaCore.Instance.luaSprite.ContainsKey(spriteID))
        {
            SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
            spriteRenderer.sprite = LuaCore.Instance.luaSprite[spriteID];
        }
    }

    public static void SetFilpX(int InstanceIDGameObject, int InstanceIDComponent, bool bol)
    {
        SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        spriteRenderer.flipX = bol;

    }

    public static void SetFilpY(int InstanceIDGameObject, int InstanceIDComponent, bool bol)
    {
        SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        spriteRenderer.flipY = bol;

    }

    public static bool GetFilpX(int InstanceIDGameObject, int InstanceIDComponent)
    {
        SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return spriteRenderer.flipX;
    }

    public static bool GetFilpY(int InstanceIDGameObject, int InstanceIDComponent)
    {
        SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return spriteRenderer.flipY;
    }

    public static Table GetSize(int InstanceIDGameObject, int InstanceIDComponent)
    {
        SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        Vector3 size = spriteRenderer.size;
        return LuaCore.Instance.ConvertV3ToTable(size);
    }

    public static void SetSize(int InstanceIDGameObject, int InstanceIDComponent, Table tableSize)
    {
        SpriteRenderer spriteRenderer = (SpriteRenderer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        Vector3 size = LuaCore.Instance.ConvertTableToVector3(tableSize);
        spriteRenderer.size = size;
    }
}
