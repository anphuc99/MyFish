---@class StateLogout : StateScriptable
local StateLogout = class("StateLogout", StateLogout)
StateLogout.__path = __path

---@param executer FSMC_Executer
function StateLogout:OnStateEnter(executer)
    SceneLoader:Load(Constant.Scene.Login)
    Unity.Logout()
end

_G.StateLogout = StateLogout