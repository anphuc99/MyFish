---@class Tab : MonoBehaviour
---@field content Transform
---@field text TextMeshProGUI
---@field button Button
---@field image Image
---@field scroll GameObject
local Tab = class("Tab", MonoBehaviour)
Tab.__path = __path

_G.Tab = Tab