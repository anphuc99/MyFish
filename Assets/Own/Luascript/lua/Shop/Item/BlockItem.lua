---@class BlockItem : MonoBehaviour
---@field block GameObject
---@field text TextMeshProGUI
local BlockItem = class("BlockItem", MonoBehaviour)
BlockItem.__path = __path

_G.BlockItem = BlockItem