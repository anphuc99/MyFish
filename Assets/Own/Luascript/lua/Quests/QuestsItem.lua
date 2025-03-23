---@class QuestsItem : MonoBehaviour
---@field txtQuatity TextMeshProGUI
---@field txtTitle TextMeshProGUI
local QuestsItem = class("QuestsItem", MonoBehaviour)
QuestsItem.__path = __path

function QuestsItem:SetQuatity(current, Quantity)
    self.txtQuatity:SetText(current .. "/".. Quantity)
end

function QuestsItem:SetTitle(title)
    self.txtTitle:SetText(title)
end

_G.QuestsItem = QuestsItem

