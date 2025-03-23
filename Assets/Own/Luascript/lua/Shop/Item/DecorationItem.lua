---@class DecorationItem : MonoBehaviour
---@field name TextMeshProGUI
---@field thumbnail Image
---@field level TextMeshProGUI
---@field gold TextMeshProGUI
---@field experience TextMeshProGUI
---@field pay PaymentMethod
---@field blockItem BlockItem
local DecorationItem = class("DecorationItem", MonoBehaviour)
DecorationItem.__path = __path

function DecorationItem:SetData(data)
    self.data = data
end

function DecorationItem:GetData()
    return self.data
end

_G.DecorationItem = DecorationItem