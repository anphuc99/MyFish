---@class Transform : Component
local Transform, base = class("Transform", Component)

---@param vector3 Vector3
function Transform:Move(vector3)    
    APITransfrom.Move(self:GetInstanceID(), {x = vector3.x, y = vector3.y, z = vector3.z})
end

function Transform:StopMove()
    APITransfrom.StopMove(self:GetInstanceID())
end

---@return Quaternion
function Transform:GetRotation()
    local quaternion = APITransfrom.GetRotation(self:GetInstanceID())
    return Quaternion.new(quaternion.x, quaternion.y, quaternion.z, quaternion.w)
end

---@param quaternion Quaternion
function Transform:SetRotation(quaternion)
    APITransfrom.SetRotation(self:GetInstanceID(), quaternion:toTable())
end

---@return Vector3
function Transform:GetLocalPosition()
    return Vector3.Copy(APITransfrom.GetLocalPosition(self:GetInstanceID()))
end

---@param vector3 Vector3
function Transform:SetLocalPosition(vector3)
    APITransfrom.SetLocalPosition(self:GetInstanceID(), vector3:toTable())
end

---@return Vector3
function Transform:GetLocalScale()
    return Vector3.Copy(APITransfrom.GetLocalScale(self:GetInstanceID()))
end

---@param vector3 Vector3
function Transform:SetLocalScale(vector3)
    APITransfrom.SetLocalScale(self:GetInstanceID(), vector3:toTable())
end

---@param vector3 Vector3
function Transform:SmoothRotate(vector3)
    APITransfrom.SetSmootRote(self:GetInstanceID(), vector3:toTable())
end

function Transform:StopSmootRote()
    APITransfrom.StopSmootRote(self:GetInstanceID())
end

---@param vector3 Vector3
function Transform:SetPosition(vector3)
    if type(vector3) == "table" and vector3.__cname == "Vector3" then        
        APITransfrom.SetPosition(self:GetInstanceID(), {x = vector3.x, y = vector3.y, z = vector3.z})
    else
        error("value not Vector3")
    end
end
---@return Vector3
function Transform:GetPosition()
    local v3 = APITransfrom.GetPosition(self:GetInstanceID())
    return Vector3.new(v3.x, v3.y, v3.z)
end

function Transform:GetChildCount()
    return APITransfrom.GetChildCount(self:GetInstanceID())
end

---@return Vector3
function Transform:GetLossyScale()
    local v3 = APITransfrom.GetLossyScale(self:GetInstanceID())
    return Vector3.new(v3.x, v3.y, v3.z)
end

---@return Transform
function Transform:GetChild(index)
    local t = APITransfrom.GetChild(self:GetInstanceID(), index - 1)
    ---@type Transform
    local transform = Lib.GetOrAddTransform(t.transform, t.gameObject)
    return transform
end

---@return Transform[]
function Transform:GetAllChild()
    local t = APITransfrom.GetAllChild(self:GetInstanceID())    
    local child = {}
    for index, value in ipairs(t) do        
        local transform = Lib.GetOrAddTransform(value.transform, value.gameObject)
        table.insert(child, transform)
    end
    return child
end




---@return Transform
function Transform:GetParent()
    local t = APITransfrom.GetParent(self:GetInstanceID())
    if not t then
        return nil
    end
    ---@type Transform
    local transform = Lib.GetOrAddTransform(t.transform, t.gameObject)
    return transform
end

---@param parent Transform
function Transform:SetParent(parent, worldPositionStays)
    if worldPositionStays == nil then
        worldPositionStays = false
    end
    APITransfrom.SetParent(self:GetInstanceID(), parent:GetInstanceID(), worldPositionStays)
end

function Transform:LockAt(Vector3)
    APITransfrom.LockAt(self:GetInstanceID(), Vector3:toTable())
end

_G.Transform = Transform