---@class GameObject
---@field transform Transform
GameObject = class("GameObject")

function GameObject:ctor(InstanceID)        
    self.prototype = {
        _enable = true,
        _instanceID = InstanceID
    }
end
---@return Component
function GameObject:AddComponent(classname)
    return Unity.AddComponent(self:GetInstanceID(), classname)
end

function GameObject:GetComponent(classname)
    return Lib.GetComponent(self:GetInstanceID(), classname)
end

function GameObject:SetActive(active)
    Unity.SetObjectActive(self:GetInstanceID(), active)
    self.prototype._enable = active
end

function GameObject:GetInstanceID()
    return self.prototype._instanceID
end

function GameObject:GetActive()
    return self.prototype._enable
end