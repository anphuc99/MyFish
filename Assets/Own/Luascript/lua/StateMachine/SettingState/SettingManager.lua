---@class SettingManager : MonoBehaviour
---@field stateMachine FSMC_Executer
local SettingManager = class("SettingManager", MonoBehaviour)
SettingManager.__path = __path

function SettingManager:BtnSettingOnClick()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self.stateMachine:SetTrigger("OpenPopupSetting")
end

_G.SettingManager = SettingManager
