---@class Image : Component
local Image,base = class("Image", Component)

-- function Image:ctor(InstanceID)
--     base.ctor(self, InstanceID)
-- end

---@param sprite Sprite
function Image:SetSprite(sprite)
    self.sprite = sprite
    APIImage.SetSprite(sprite:GetInstanceID(), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

---@param color Color
function Image:SetColor(color)
    APIImage.SetColor(color:toTable(), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Image:GetColor()
    local color = APIImage.GetColor(self.gameObject:GetInstanceID(), self:GetInstanceID())
    return Color.Copy(color)
end

function Image:GetSprite()
    return self.sprite
end

function Image:GetRaycastTarget()
    return APIImage.GetRaycastTarget(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

_G.Image = Image