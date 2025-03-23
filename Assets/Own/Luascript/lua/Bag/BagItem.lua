---@class BagItem : MonoBehaviour
---@field thumbnail Image
---@field amount TextMeshProGUI
---@field button Button
local BagItem = class("BagItem", MonoBehaviour)
BagItem.__path = __path

function BagItem:OnDestroy()
    self.button:onClickRemoveAll()
end

_G.BagItem = BagItem