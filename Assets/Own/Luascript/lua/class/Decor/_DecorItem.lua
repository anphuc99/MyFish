---@class _DecorItem
local _DecorItem = class("_DecorItem")

function _DecorItem:ctor(value)
    self.UID = tonumber(value.id)
    self.amount = tonumber(value.amount)
end

_G._DecorItem=_DecorItem