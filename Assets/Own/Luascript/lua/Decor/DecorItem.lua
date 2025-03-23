---@class DecorItem : MonoBehaviour
---@field thumbnail Image
---@field amount TextMeshProGUI
---@field button Button
local DecorItem = class("DecorItem", MonoBehaviour)
DecorItem.__path = __path

function DecorItem:OnDestroy()
    self.button:onClickRemoveAll()
end

_G.DecorItem = DecorItem