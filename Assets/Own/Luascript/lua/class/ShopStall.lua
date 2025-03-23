---@class ShopStall : Item
local ShopStall, base = class("ShopStall", Item)

function ShopStall:ctor(value)
    base.ctor(self, value)
    self.price = value.price
end

_G.ShopStall = ShopStall