---@class StateScriptable : ScriptableObject
---@field StateInit fun(FSMC_Executer: FSMC_Executer)
---@field OnStateEnter fun(FSMC_Executer: FSMC_Executer)
---@field OnStateExit fun(FSMC_Executer: FSMC_Executer)
StateScriptable = class("StateScriptable", ScriptableObject)