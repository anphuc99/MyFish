using DevMini.Plugin.Popup;
using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuaScriptPopupAnimation : LuaScript, IPopupAnimation
{
    public void OnShow(GameObject view, Action onComplete)
    {
        DynValue func = luaObject.Table.Get("OnShow");
        if (func.Type == DataType.Function)
        {
            LuaSerializable luaSerializable = new LuaSerializable()
            {
                param = "param",
                type = LuaType.GameObject,
                gameObject = view
            };
            Table table = ConvertLuaParamToLua(new List<LuaSerializable> {luaSerializable});
            func.Function.CallFunction(luaObject,table.Get("param"), onComplete);
        }
    }
    public void OnHide(GameObject view, Action onComplete)
    {
        DynValue func = luaObject.Table.Get("OnHide");
        if (func.Type == DataType.Function)
        {
            LuaSerializable luaSerializable = new LuaSerializable()
            {
                param = "param",
                type = LuaType.GameObject,
                gameObject = view
            };
            Table table = ConvertLuaParamToLua(new List<LuaSerializable> { luaSerializable });
            func.Function.CallFunction(luaObject, table.Get("param"), onComplete);
        }
    }
}
