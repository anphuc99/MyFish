---@class ExchangeItem : MonoBehaviour
---@field value1 TextMeshProGUI
---@field value2 TextMeshProGUI
local ExchangeItem = class("ExchangeItem", MonoBehaviour)
ExchangeItem.__path = __path

function ExchangeItem:SetValue(value1, value2)
    self.value1:SetText(value1)
    self.value2:SetText(value2)
    self.v1 = value1
    self.v2 = value2
end

function ExchangeItem:OnClick()
    self.parent:OnExchange(self)
end

_G.ExchangeItem = ExchangeItem
