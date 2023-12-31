---@class Image : Component
local Image,base = class("Image", Component)

-- function Image:ctor(InstanceID)
--     base.ctor(self, InstanceID)
-- end

---@param sprite Sprite
function Image:SetSprite(sprite)
    self.sprite = sprite
    Unity.UISetImage(sprite:GetInstanceID(), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Image:GetSprite()
    return self.sprite
end

rawset(_G, "Image", Image)