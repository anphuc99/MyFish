---@class FishItem : MonoBehaviour
---@field name TextMeshProGUI
---@field thumbnail Transform
---@field level TextMeshProGUI
---@field growth TextMeshProGUI
---@field income TextMeshProGUI
---@field experience TextMeshProGUI
---@field pay PaymentMethod
---@field blockItem BlockItem
local FishItem = class("FishItem", MonoBehaviour)
FishItem.__path = __path

function FishItem:SetData(data)
    self.data = data
end

function FishItem:GetData()
    return self.data
end

_G.FishItem = FishItem