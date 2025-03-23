using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class LuaEvent
{
    public static Dictionary<string, Action<DynValue>> luaEvent = new Dictionary<string, Action<DynValue>>();

    public static void Register(string nameEvent, Action<DynValue> action)
    {
        if (!luaEvent.ContainsKey(nameEvent))
        {
            luaEvent.Add(nameEvent, action);
        }
        else
        {
            luaEvent[nameEvent] += action;
        }
    }

    public static void Unregister(string nameEvent, Action<DynValue> action)
    {
        luaEvent[nameEvent] -= action;
    }

    public static void Emit(string nameEvent, DynValue value)
    {
        luaEvent[nameEvent]?.Invoke(value);
    }
}
