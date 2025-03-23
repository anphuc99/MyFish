---@class StateTest : StateScriptable
local StateTest = class("StateTest", StateScriptable)
StateTest.__path = __path

---@param FSMC_Executer FSMC_Executer
function StateTest:StateInit(FSMC_Executer)
    print("StateInit")
end

---@param FSMC_Executer FSMC_Executer
function StateTest:OnStateEnter(FSMC_Executer)
    print("OnStateEnter")
end
---@param FSMC_Executer FSMC_Executer
function StateTest:OnStateExit(FSMC_Executer)
    print("OnStateExit")
end

_G.StateTest = StateTest