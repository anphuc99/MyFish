using FSMC.Runtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuaStateController : FSMC_Behaviour
{
    public string onStateEnter;
    public string onStateExit;

    public override void StateInit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
    }

    public override void OnStateEnter(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!string.IsNullOrEmpty(onStateEnter))
        {
            LuaFSMC_Executer luaExetuer = executer as LuaFSMC_Executer;
            LuaCore.ExecuteFuntion(luaExetuer.controller.luaObject, onStateEnter);
        }
    }

    public override void OnStateExit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!string.IsNullOrEmpty(onStateExit))
        {
            LuaFSMC_Executer luaExetuer = executer as LuaFSMC_Executer;
            LuaCore.ExecuteFuntion(luaExetuer.controller.luaObject, onStateExit);
        }
    }

    public override void OnStateUpdate(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
    }


}
