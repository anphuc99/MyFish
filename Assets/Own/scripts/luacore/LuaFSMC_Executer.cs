using FSMC.Runtime;
using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuaFSMC_Executer : FSMC_Executer
{
    public LuaScript controller;
    public List<LuaSerializable> luaParams;
    public static Dictionary<FSMC_Executer, DynValue> globalExecuter = new Dictionary<FSMC_Executer, DynValue>();
    private void OnDestroy()
    {
        globalExecuter.Remove(this);
    }
}
