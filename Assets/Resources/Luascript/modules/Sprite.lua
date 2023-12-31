---@class Sprite

Sprite = class("Sprite")

function Sprite:ctor(InstanceID)        
    self.prototype = {        
        _instanceID = InstanceID
    }
end

function Sprite:GetInstanceID()
    return self.prototype._instanceID
end