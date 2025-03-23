using FSMC.Runtime;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class LuaState : FSMC_Behaviour
{    
    public LuaStateScriptable luaStateScriptable;
    private LuaStateScriptable _luaStateScriptable;
    public override void StateInit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {        
        if (luaStateScriptable != null)
        {
            if(_luaStateScriptable == null)
            {
                _luaStateScriptable = GameObject.Instantiate(luaStateScriptable);
            }
            _luaStateScriptable.StateInit(stateMachine, executer);
        }
    }
    public override void OnStateEnter(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if(_luaStateScriptable != null)
        {
            _luaStateScriptable.OnStateEnter(stateMachine, executer);
        }
    }
    public override void OnStateUpdate(FSMC_Controller stateMachine, FSMC_Executer executer)
    {

    }
    public override void OnStateExit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (_luaStateScriptable != null)
        {
            _luaStateScriptable.OnStateExit(stateMachine, executer);            
        }
    }
}
