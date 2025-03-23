using FSMC.Runtime;
using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[CreateAssetMenu(fileName = "Lua Scriptable Object", menuName = "lua/create state object")]
public class LuaStateScriptable : LuaScriptableObject
{
    private DynValue luaExecuter;
    public void StateInit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!LuaFSMC_Executer.globalExecuter.ContainsKey(executer))
        {
            LuaSerializable luaSerializable = new LuaSerializable();
            luaSerializable.type = LuaType.FSMC_Executer;
            luaSerializable.FSMC_Executer = executer;
            luaSerializable.param = "param";
            luaExecuter = LuaScript.ConvertLuaParamToLua(new List<LuaSerializable>() { luaSerializable }).Get("param");            
        }
        else
        {
            luaExecuter = LuaFSMC_Executer.globalExecuter[executer];
        }
        try
        {
            LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.CallFunction(luaObject, "StateInit", luaExecuter);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }
    public void OnStateEnter(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        try
        {
#if !UNTY_BUILD_RELEASE
            ReCompile();
#endif
            LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.CallFunction(luaObject, "OnStateEnter", luaExecuter);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }    
    public void OnStateExit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        try
        {
            LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.CallFunction(luaObject, "OnStateExit", luaExecuter);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }
}
