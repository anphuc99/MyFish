---@class ShopFish
local ShopFish = class("ShopFish")

function ShopFish:ctor(value)
    self.UID = value.UID
    self.name = value.name
    self.lv_required = value.lv_required
    self.growth_time = value.growth_time
    self.price = value.price
    self.growth = value.growth
    self.breed = value.breed
end

_G.ShopFish = ShopFish