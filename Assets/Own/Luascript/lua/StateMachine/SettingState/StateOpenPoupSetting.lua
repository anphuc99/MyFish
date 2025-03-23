---@class StateOpenPoupSetting : StateScriptable
local StateOpenPoupSetting = class("StateOpenPoupSetting", StateScriptable)
StateOpenPoupSetting.__path = __path

---@param executer FSMC_Executer
function StateOpenPoupSetting:OnStateEnter(executer)
    PopupManager:show(Constant.PoppupID.Popup_setting, {
        onLogoutClick = function ()
            executer:SetTrigger("onLogoutClick")
        end,
        onClose = function ()
            executer:SetTrigger("onClose")
        end
    })
end

_G.StateOpenPoupSetting = StateOpenPoupSetting