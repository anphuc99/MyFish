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

---@param url string
---@param callback function
---@param callbackError any
function Sprite:CreateSpriteFromURL(url, callback, callbackError)
    APISprite.CreateSpriteFromURL(url, callback, callbackError)
end

function Sprite:LoadImage(dataBase64)
    return APISprite.LoadImage(dataBase64)
end