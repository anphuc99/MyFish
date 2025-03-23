---@class Item 
local Item = class("Item")


function Item:ctor(value)
    self.UID = value.UUID
    self.name = value.name
    self.lv_required = value.lv_required
    self.type = value.type
    self.description = value.describe
    self.data = value.data
end

---@return Sprite
function Item:GetSprite()
    return DataManager.Instance:GetItemSprite(self.UID)
end

_G.Item = Item