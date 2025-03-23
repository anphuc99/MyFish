---@class SpriteRenderer : Component
local SpriteRenderer,base = class("SpriteRenderer", Component)

-- function Image:ctor(InstanceID)
--     base.ctor(self, InstanceID)
-- end

---@param sprite Sprite
function SpriteRenderer:SetSprite(sprite)
    self.sprite = sprite
    APISpriteRenderer.SetSprite(sprite:GetInstanceID(), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function SpriteRenderer:SetFilpX(bool)
    APISpriteRenderer.SetFilpX(self.gameObject:GetInstanceID(), self:GetInstanceID(), bool)
end

function SpriteRenderer:SetFilpY(bool)
    APISpriteRenderer.SetFilpY(self.gameObject:GetInstanceID(), self:GetInstanceID(), bool)    
end

function SpriteRenderer:GetFilpX()
    APISpriteRenderer.GetFilpX(self.gameObject:GetInstanceID(), self:GetInstanceID())        
end

function SpriteRenderer:GetFilpY()
    APISpriteRenderer.GetFilpY(self.gameObject:GetInstanceID(), self:GetInstanceID())            
end

function SpriteRenderer:GetSprite()
    return self.sprite
end

---@return Vector3
function SpriteRenderer:GetSize()
    local size = APISpriteRenderer.GetSize(self.gameObject:GetInstanceID(), self:GetInstanceID())                
    return Vector3.Copy(size)
end

---@param size Vector3
function SpriteRenderer:SetSize(size)
    APISpriteRenderer.SetSize(self.gameObject:GetInstanceID(), self:GetInstanceID(), size:toTable())    
end

_G.SpriteRenderer = SpriteRenderer