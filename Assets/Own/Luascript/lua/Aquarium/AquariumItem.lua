---@class AquariumItem : MonoBehaviour
---@field clrSelect Color
---@field clrUnSelect Color
---@field clrLockSelect Color
---@field imgItem Image
---@field lock Image
---@field btnItem Button
local AquariumItem = class("AquariumItem", MonoBehaviour)
AquariumItem.__path = __path

function AquariumItem:Select()
    self.imgItem:SetColor(self.clrSelect)
end

function AquariumItem:UnSelect()
    self.imgItem:SetColor(self.clrUnSelect)
end

function AquariumItem:Lock(lock)
    self.lock.gameObject:SetActive(lock)
    self.lock = lock
    if lock then
        self.imgItem:SetColor(self.clrLockSelect)        
    end
end

function AquariumItem:OnChange()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    if not self.lock then
        Event:Emit(Constant.Event.OnChangeAquarium, self.index)        
    end
end

_G.AquariumItem = AquariumItem
