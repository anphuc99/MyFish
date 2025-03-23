---@class PopupSetting : MonoBehaviour
---@field volume Slider
---@field sound Slider
---@field name TextMeshProGUI
---@field UUID TextMeshProGUI
local PopupSetting = class("PopupSetting", MonoBehaviour)
PopupSetting.__path = __path

function PopupSetting:OnBeginShow()
   self:SetUID()
    self:SetName()
    local volume = DataLocalManager:GetValue(Constant.Data.volume) or 100
    local sound = DataLocalManager:GetValue(Constant.Data.sound) or 100
    if(volume ~= nil) then
        self.volume:SetValue(volume)        
    end
    if sound ~= nil then
        self.sound:SetValue(sound)        
    end
end

function PopupSetting:Logout()
    if type(self.params.onLogoutClick) == "function" then
        self.params.onLogoutClick()        
    end 
end

function PopupSetting:Close()
    if type(self.params.onClose) == "function" then
        self.params.onClose()        
    end 
end

function PopupSetting:OnSetVolume()
    DataLocalManager:SetValue(Constant.Data.volume, self.volume:GetValue())
    Event:Emit(Constant.Event.OnChangeVolume)
end

function PopupSetting:OnSetSound()
    DataLocalManager:SetValue(Constant.Data.sound, self.sound:GetValue())
    Event:Emit(Constant.Event.OnChangeVolume)
end

function PopupSetting:SetName()
    local player=Me:get_player():get()
    local name="Null"
    if player.name then
        name=player.name
    end
    self.name:SetText(name)
end
function PopupSetting:SetUID()
    local player=Me:get_player():get()
    local UUID="Null"
    if player.friend_code then
        UUID=player.friend_code
    end
    self.UUID:SetText(UUID)
end

function PopupSetting:CopyUID()    
    Unity.CopyText(self.UUID:GetText())
    Toat:Show("Copy UID thành công", Constant.PoppupID.Popup_Toat)
end

_G.PopupSetting = PopupSetting