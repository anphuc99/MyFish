---@class StallItem : MonoBehaviour
---@field name TextMeshProGUI
---@field thumbnail Image
---@field pay PaymentMethod
local StallItem = class("StallItem", MonoBehaviour)
StallItem.__path = __path

_G.StallItem = StallItem