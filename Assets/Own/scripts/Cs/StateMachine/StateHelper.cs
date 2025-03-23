using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FSMC.Runtime;
using System;
using UnityEngine.Events;

[Serializable]
public class StateHelper : FSMC_Behaviour
{
    public string stateInit;
    public string onStateEnter;
    public string onStateUpdate;
    public string onStateExit;
    public override void StateInit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!string.IsNullOrEmpty(stateInit))
        {
            CustomFSMC_Execute customFSMC_Execute = (CustomFSMC_Execute)executer;
            customFSMC_Execute.ExecuteAction(stateInit);
        }
    }
    public override void OnStateEnter(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!string.IsNullOrEmpty(onStateEnter))
        {
            CustomFSMC_Execute customFSMC_Execute = (CustomFSMC_Execute)executer;
            customFSMC_Execute.ExecuteAction(onStateEnter);
        }
    }

    public override void OnStateUpdate(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!string.IsNullOrEmpty(onStateUpdate))
        {
            CustomFSMC_Execute customFSMC_Execute = (CustomFSMC_Execute)executer;
            customFSMC_Execute.ExecuteAction(onStateUpdate);
        }
    }

    public override void OnStateExit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        if (!string.IsNullOrEmpty(onStateExit))
        {
            CustomFSMC_Execute customFSMC_Execute = (CustomFSMC_Execute)executer;
            customFSMC_Execute.ExecuteAction(onStateExit);
        }
    }
}