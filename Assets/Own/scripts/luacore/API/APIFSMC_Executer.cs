using FSMC.Runtime;
using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APIFSMC_Executer
{
    public static void SetFloat(string name, float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        _runtimeController.SetFloat(name, value);
    }

    public static float GetFloat(string name, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return _runtimeController.GetFloat(name);
    }

    public static void SetInt(string name, int value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        _runtimeController.SetInt(name, value);
    }
    public static int GetInt(string name, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return _runtimeController.GetInt(name);
    }
    public static void SetBool(string name, bool value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        _runtimeController.SetBool(name, value);
    }
    public static bool GetBool(string name, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return _runtimeController.GetBool(name);
    }
    public static void SetTrigger(string name, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        _runtimeController.SetTrigger(name);
    }

    public static FSMC_State GetCurrentState(int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return _runtimeController.GetCurrentState();
    }
    public static void SetCurrentState(string name, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        _runtimeController.SetCurrentState(name);
    }
    public static FSMC_State GetState(string name, int InstanceIDGameObject, int InstanceIDComponent)
    {
        FSMC_Executer _runtimeController = (FSMC_Executer)LuaCore.Instance.luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        return _runtimeController.GetState(name);
    }
}
