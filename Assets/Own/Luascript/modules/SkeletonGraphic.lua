---@class SkeletonGraphic : Component
SkeletonGraphic = class("SkeletonGraphic", Component)

function SkeletonGraphic:GetColor()
    local t = APISkeletonGraphic.GetColor(self.gameObject:GetInstanceID(), self:GetInstanceID())
    return Color.new(t.r, t.g, t.b, t.a)
end

---@param color Color
function SkeletonGraphic:SetColor(color)
    APISkeletonGraphic.SetColor(self.gameObject:GetInstanceID(), self:GetInstanceID(), color:toTable())
end