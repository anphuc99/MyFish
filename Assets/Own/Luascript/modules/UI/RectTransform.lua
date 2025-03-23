---@class RectTransform : Transform
local RectTransform, base = class("RectTransform", Transform)

function RectTransform:GetAnchoredPosition()
    local v3 = APIRectTransform.GetAnchoredPosition(self:GetInstanceID())
    return Vector3.Copy(v3)
end

---@param v3 Vector3
function RectTransform:SetAnchoredPosition(v3)
    APIRectTransform.SetAnchoredPosition(self:GetInstanceID(), v3:toTable())
end

---@return Rect
function RectTransform:GetRect()
    local r = APIRectTransform.GetRect(self:GetInstanceID())
    return Rect.Copy(r)
end
---@return Vector3
function RectTransform:GetSizeData()
    local v3 = APIRectTransform.GetSizeData(self:GetInstanceID())
    return Vector3.Copy(v3)
end
---@param vector3 Vector3
function RectTransform:SetSizeData(vector3)
    APIRectTransform.SetSizeData(self:GetInstanceID(), vector3:toTable())
end


_G.RectTransform = RectTransform