---@class GameObject
---@field transform Transform
GameObject = class("GameObject")

function GameObject:ctor(InstanceID)        
    self.prototype = {
        _instanceID = InstanceID
    }
end
---@return Component
function GameObject:AddComponent(classname)
    return APIGameObject.AddComponent(self:GetInstanceID(), classname) -- API được truyền từ c#
end

function GameObject:GetComponent(classname)
    return Lib.GetComponent(self:GetInstanceID(), classname)
end

function GameObject:SetActive(active)
    APIGameObject.SetActive(self:GetInstanceID(), active)
end

function GameObject:GetInstanceID()
    return self.prototype._instanceID
end

function GameObject:GetActive()
    return APIGameObject.GetActive(self:GetInstanceID())
end

function GameObject:IsDestroy()
    return not Lib.CheckExistsGameObject(self:GetInstanceID())
end

function GameObject:GetName()
    return APIGameObject.GetName(self:GetInstanceID())
end