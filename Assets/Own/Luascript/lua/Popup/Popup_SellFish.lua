---@class Popup_SellFish : MonoBehaviour
---@field title TextMeshProGUI
---@field description TextMeshProGUI
---@field coin TextMeshProGUI
---@field exp TextMeshProGUI
---@field btnYesText TextMeshProGUI
---@field btnYes Button
---@field btnNoText TextMeshProGUI
---@field btnNo Button
local Popup_SellFish = class("Popup_SellFish", MonoBehaviour)
Popup_SellFish.__path = __path

function Popup_SellFish:OnBeginShow()
    local params = self.params 

    self.title:SetText(params.title)
    self.description:SetText(params.desrciption)
    self.coin:SetText(params.coin)
    self.exp:SetText(params.exp)
    self:SetButton(params.btnYes, self.btnYes, self.btnYesText)
    self:SetButton(params.btnNo, self.btnNo, self.btnNoText)
end

---@param param any
---@param button Button
---@param buttonText TextMeshProGUI
function Popup_SellFish:SetButton(param, button, buttonText)
    buttonText:SetText(param.text)
    if param.onClick then
        button:onClickAddListener(param.onClick)        
    end
    if param.disable then
        button.gameObject:SetActive(not param.disable)
    end
end

function Popup_SellFish:OnEndHide()
    self.btnYes:onClickRemoveAll()
    self.btnNo:onClickRemoveAll()
end

_G.Popup_SellFish = Popup_SellFish