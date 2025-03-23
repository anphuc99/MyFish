using DevMini.Plugin.Popup;
using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class LuaScriptPopup : LuaScript, IPopupScript
{
    public string PopupID { get; set; }
    public Kvp[] param { get; set; }
    public DynValue paramLua { get; set; }
    public void OnBeginHide()
    {
        LuaCore.ExecuteFuntion(luaObject, "OnBeginHide");
    }

    public void OnBeginShow()
    {
        try
        {
            if (paramLua != null)
            {
                luaObject.Table.Set("params", paramLua);
            }
            luaObject.Table.Set("PopupID", DynValue.NewString(PopupID));
            LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.CallFunction(luaObject, "OnBeginShow");        
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError($"Lua runtime popup {PopupID} error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }

    public void OnEndHide()
    {
        LuaCore.ExecuteFuntion(luaObject, "OnEndHide");
    }

    public void OnEndShow()
    {
        LuaCore.ExecuteFuntion(luaObject, "OnEndShow");
    }
}
