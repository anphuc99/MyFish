---@class ShopDecoration
local ShopDecoration = class("ShopDecoration")

function ShopDecoration:ctor(value)
    self.UID = value.UUID
    self.name = value.name
    self.lv_required = value.lv_required
    self.price = value.price
    self.bonus = value.bonus
end

_G.ShopDecoration = ShopDecoration