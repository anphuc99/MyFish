using FSMC;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FSMC.Runtime
{
    [Serializable]
    public abstract class FSMC_Behaviour
    {
        public bool enabled = true;

        public abstract void StateInit(FSMC_Controller stateMachine, FSMC_Executer executer);
        public abstract void OnStateEnter(FSMC_Controller stateMachine, FSMC_Executer executer);

        public abstract void OnStateUpdate(FSMC_Controller stateMachine, FSMC_Executer executer);

        public abstract void OnStateExit(FSMC_Controller stateMachine, FSMC_Executer executer);
    }
}
