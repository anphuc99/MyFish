---@class PopupReward : MonoBehaviour
---@field imgItem Image
---@field name TextMeshProGUI
---@field amount TextMeshProGUI
---@field reward GameObject
---@field description TextMeshProGUI
local PopupReward = class("PopupReward", MonoBehaviour)
PopupReward.__path = __path

function PopupReward:OnBeginShow()
    self.num = 1
    self:Show(self.num)
end

function PopupReward:Show(num)
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Gift)
    local params = self.params[tostring(num)] 
    local itemUID = params.UID 
    local amount = params.amount or 1
    local name = params.name or ""
    local description = params.description or ""
    self.imgItem:SetSprite(DataManager.Instance:GetItemSprite(itemUID))
    self.name:SetText(name)
    if amount > 1 then
        self.amount:SetText(tostring(amount))        
    else
        self.amount:SetText("")
    end
    self.description:SetText(description)
    PopupManager:LockUI(true)
    self.reward.transform:SetLocalScale(Vector3.zero)
    LeanTween:scale(self.reward, Vector3.one, 0.2):setEase(LeanTweenType.easeInOutElastic):setOnComplete(function ()
        PopupManager:LockUI(false)
    end)
end

function PopupReward:Hide()
    PopupManager:hide(self.PopupID)
end

function PopupReward:OnClick()
    self.num = self.num + 1
    local check = self.params[tostring(self.num)] 
    if check then
        self:Show(self.num)
    else
        self:Hide()
    end
end

function PopupReward:OnEndHide()
    if self.params.onHide then
        self.params.onHide()
    end
end

_G.PopupReward = PopupReward
