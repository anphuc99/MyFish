---@class StateHidePopupSetting : StateScriptable
local StateHidePopupSetting = class("StateHidePopupSetting", StateScriptable)
StateHidePopupSetting.__path = __path
---@param executer FSMC_Executer
function StateHidePopupSetting:OnStateEnter(executer)
    PopupManager:hide(Constant.PoppupID.Popup_setting)
end

_G.StateHidePopupSetting = StateHidePopupSetting