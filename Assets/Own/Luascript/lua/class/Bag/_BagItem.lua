---@class _BagItem
local _BagItem = class("_BagItem")

function _BagItem:ctor(value)
    self.UID = tonumber(value.id)
    self.amount = tonumber(value.amount)
end

---@return Sprite
function _BagItem:GetSprite()
    return self:GetInfo():GetSprite()
end

function _BagItem:GetInfo()
    local data = Me:GetItemByID(self.UID)
	return data
end

function _BagItem:AddAmount(amount)
	self.amount = self.amount + amount
end

_G._BagItem=_BagItem