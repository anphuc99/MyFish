using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APILuaEvent
{
    public static int eventID = 0;
    public static Dictionary<int, Action<DynValue>> cacheEvent = new Dictionary<int, Action<DynValue>>();
    public static int Register(string nameEvent, Closure func)
    {
        eventID++;
        Action<DynValue> action = (value) => func.CallFunction(value);
        LuaEvent.Register(nameEvent, action);
        cacheEvent[eventID] = action;
        return eventID;
    }

    public static void Unregister(string nameEvent, int eventID)
    {
        var action = cacheEvent[eventID];
        LuaEvent.Unregister(nameEvent, action);
        cacheEvent.Remove(eventID);
    }

    public static void Emit(string nameEvent, DynValue value)
    {
        LuaEvent.Emit(nameEvent, value);
    }
}
