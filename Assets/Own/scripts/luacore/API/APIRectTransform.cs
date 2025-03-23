using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APIRectTransform
{
    public static Table GetAnchoredPosition(int InsTransform)
    {
        RectTransform rectTransform = (RectTransform)LuaCore.Instance.luaTransform[InsTransform];
        Vector3 anchoredPosition = rectTransform.anchoredPosition;
        Table table = LuaCore.Instance.ConvertV3ToTable(anchoredPosition);
        return table;
    }

    public static void SetAnchoredPosition(int InsTransform, Table table)
    {
        RectTransform rectTransform = (RectTransform)LuaCore.Instance.luaTransform[InsTransform];
        Vector3 anchoredPosition = LuaCore.Instance.ConvertTableToVector3(table);
        rectTransform.anchoredPosition = anchoredPosition;
    }

    public static Table GetRect(int InsTransform)
    {
        RectTransform rectTransform = (RectTransform)LuaCore.Instance.luaTransform[InsTransform];
        Table table = LuaCore.Instance.ConvertRectToTable(rectTransform.rect);
        return table;
    }

    public static void SetSizeData(int InsTransform, Table vector3)
    {
        RectTransform rectTransform = (RectTransform)LuaCore.Instance.luaTransform[InsTransform];
        Vector3 v3 = LuaCore.Instance.ConvertTableToVector3(vector3);
        rectTransform.sizeDelta = v3;
    }

    public static Table GetSizeData(int InsTransform)
    {
        RectTransform rectTransform = (RectTransform)LuaCore.Instance.luaTransform[InsTransform];
        Vector3 size = rectTransform.sizeDelta;
        return LuaCore.Instance.ConvertV3ToTable(size);
    }
}
