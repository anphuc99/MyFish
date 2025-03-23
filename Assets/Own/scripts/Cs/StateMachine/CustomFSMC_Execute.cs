using FSMC.Runtime;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class CustomFSMC_Execute : FSMC_Executer
{
    [Serializable]
    public class StateAction
    {
        public string name;
        public UnityEvent action;
    }

    [TableList]
    public List<StateAction> actions;

    public void ExecuteAction(string actionName)
    {
        StateAction action = actions.Find(x=>x.name == actionName); 
        if(action != null )
        {
            action.action?.Invoke();
        }
    }
}
