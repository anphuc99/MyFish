---@class Transform : Component
local Transform, base = class("Transform", Component)

---@param vector3 Vector3
function Transform:Move(vector3)
    Unity.TransformMove(self:GetInstanceID(), {x = vector3.x, y = vector3.y, z = vector3.z})
end

function Transform:StopMove()
    Unity.TransformStopMove(self:GetInstanceID())
end

---@return Quaternion
function Transform:GetRotation()
    return Unity.TransformGetRotation(self:GetInstanceID())
end

---@param quaternion Quaternion
function Transform:SetRotation(quaternion)
    Unity.TransformSetRotation(self:GetInstanceID(), quaternion:toTable())
end

---@return Vector3
function Transform:GetLocalPosition()
    return Unity.TransformGetLocalPosition(self:GetInstanceID())
end

---@param vector3 Vector3
function Transform:SetLocalPosition(vector3)
    Unity.TransformSetLocalPosition(self:GetInstanceID(), vector3)
end

---@param vector3 Vector3
function Transform:SmoothRotate(vector3)
    Unity.TransformSetSmootRote(self:GetInstanceID(), vector3:toTable())
end

function Transform:StopRotate()
    Unity.TransformStopSmootRote(self:GetInstanceID())
end

---@param vector3 Vector3
function Transform:SetPosition(vector3)
    if type(vector3) == "table" and vector3.__cname == "Vector3" then        
        Unity.TransformSetPosition(self:GetInstanceID(), {x = vector3.x, y = vector3.y, z = vector3.z})
    else
        error("value not Vector3")
    end
end
---@return Vector3
function Transform:GetPosition()
    local v3 = Unity.TransformGetPosition(self:GetInstanceID())
    return Vector3.new(v3.x, v3.y, v3.z)
end

function Transform:GetChildCount()
    return Unity.TransformGetChildCount(self:GetInstanceID())
end

---@return Transform
function Transform:GetChild(index)
    local t = Unity.TransformGetChild(self:GetInstanceID(), index - 1)
    ---@type Transform
    local transform = Lib.GetOrAddTransform(t.transform, t.gameObject)
    return transform
end

---@return Transform[]
function Transform:GetAllChild()
    local t = Unity.LuaTransformGetAllChild(self:GetInstanceID())    
    local child = {}
    for index, value in ipairs(t) do        
        local transform = Lib.GetOrAddTransform(value.transform, value.gameObject)
        table.insert(child, transform)
    end
    return child
end


rawset(_G, "Transform", Transform)