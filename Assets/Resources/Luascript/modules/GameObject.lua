---@class GameObject
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

function GameObject:SetActive(active)
    Unity.SetObjectActive(self:GetInstanceID(), active)
end

function GameObject:GetInstanceID()
    return self.prototype._instanceID
end