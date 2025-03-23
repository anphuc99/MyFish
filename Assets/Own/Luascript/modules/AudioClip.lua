---@class AudioClip
AudioClip = class("AudioClip")

function AudioClip:ctor(InstanceID)        
    self.prototype = {        
        _instanceID = InstanceID
    }
end

function AudioClip:GetInstanceID()
    return self.prototype._instanceID
end