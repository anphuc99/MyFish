---@class PopupCreateUser : MonoBehaviour
---@field inputName InputField
---@field tglMale Toggle
---@field tglFemale Toggle
 local PopupCreateUser = class("PopupCreateUser", MonoBehaviour)
PopupCreateUser.__path = __path

function PopupCreateUser:Create()
    -- AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    local Username = self.inputName:GetText()
    local gender = 1
    if self.tglFemale:IsOn() then
        gender = 2
    end
    PlayerSocket:create(Username,gender,Lib.handler(self, self.CallBack))
    -- print(Username .. " " .. self.g)
    -- ServerHandler:SendMessage("load_player", { cmd = "create", data = { name = Username, gender = self.g} }, Lib.handler(self, self.CallBack))
end

function PopupCreateUser:CallBack(data)
    if(data.code == 1 or data.code == 3) then        
        PopupManager:hide(self.PopupID)
    end
end

function PopupCreateUser:OnEndHide()
    Unity.ReLoad()
end

function PopupCreateUser:ToggleSex()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
end

_G.PopupCreateUser = PopupCreateUser
