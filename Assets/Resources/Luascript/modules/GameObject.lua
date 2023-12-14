---@class GameObject
GameObject = class("GameObject")

function GameObject:ctor(InstanceID)        
    self.prototype = {
        _enable = true,
        _instanceID = InstanceID
    }
end

function GameObject:AddComponent(classname)
    local cls = Lib.GetClass(classname)
    if cls ~= nil then
        local component = cls.new()
    end
end

function GameObject:GetInstanceID()
    return self.prototype._instanceID
end