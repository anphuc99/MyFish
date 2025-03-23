---@class LeanTweenType
LeanTweenType = {
    notUsed = 0,
    linear = 1,
    easeOutQuad = 2,
    easeInQuad = 3,
    easeInOutQuad = 4,
    easeInCubic = 5,
    easeOutCubic = 6,
    easeInOutCubic = 7,
    easeInQuart = 8,
    easeOutQuart = 9,
    easeInOutQuart = 10,
    easeInQuint = 11,
    easeOutQuint = 12,
    easeInOutQuint = 13,
    easeInSine = 14,
    easeOutSine = 15,
    easeInOutSine = 16,
    easeInExpo = 17,
    easeOutExpo = 18,
    easeInOutExpo = 19,
    easeInCirc = 20,
    easeOutCirc = 21,
    easeInOutCirc = 22,
    easeInBounce = 23,
    easeOutBounce = 24,
    easeInOutBounce = 25,
    easeInBack = 26,
    easeOutBack = 27,
    easeInOutBack = 28,
    easeInElastic = 29,
    easeOutElastic = 30,
    easeInOutElastic = 31,
    easeSpring = 32,
    easeShake = 33,
    punch = 34,
    once = 35,
    clamp = 36,
    pingPong = 37,
    animationCurve = 38
}

---@class LTDescr
LTDescr = class("LTDescr")

function LTDescr:ctor(uniqueId)
    self.uniqueId = uniqueId;
end

function LTDescr:setOnComplete(func)
    if (type(func) == "function") then
        APILTDescr.setOnComplete(self.uniqueId, func)        
        return self
    else
        error("Gọi setOnComplete phải truyền function")        
    end
end

function LTDescr:setEase(leanTweenType)    
    APILTDescr.setEase(self.uniqueId, leanTweenType)
    return self
end

function LTDescr:cancel()
    APILTDescr.cancel(self.uniqueId)
    return self    
end

function LTDescr:pause()
    APILTDescr.pause(self.uniqueId)
    return self    
end
function LTDescr:resume()
    APILTDescr.resume(self.uniqueId)
    return self    
end

---@class LeanTween
LeanTween = {}

---@param gameObject GameObject
---@param to Vector3
---@param time number
function LeanTween:move(gameObject, to, time)
    local uniqueId = APILeanTween.move(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocal(gameObject, to, time)
    local uniqueId = APILeanTween.moveLocal(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scale(gameObject, to, time)
    local uniqueId = APILeanTween.scale(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotate(gameObject, to, time)
    local uniqueId = APILeanTween.rotate(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveX(gameObject, to, time)
    local uniqueId = APILeanTween.moveX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveY(gameObject, to, time)
    local uniqueId = APILeanTween.moveY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveZ(gameObject, to, time)
    local uniqueId = APILeanTween.moveZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocalX(gameObject, to, time)
    local uniqueId = APILeanTween.moveLocalX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocalY(gameObject, to, time)
    local uniqueId = APILeanTween.moveLocalY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocalZ(gameObject, to, time)
    local uniqueId = APILeanTween.moveLocalZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scaleX(gameObject, to, time)
    local uniqueId = APILeanTween.scaleX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scaleY(gameObject, to, time)
    local uniqueId = APILeanTween.scaleY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scaleZ(gameObject, to, time)
    local uniqueId = APILeanTween.scaleZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotateX(gameObject, to, time)
    local uniqueId = APILeanTween.rotateX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotateY(gameObject, to, time)
    local uniqueId = APILeanTween.rotateY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotateZ(gameObject, to, time)
    local uniqueId = APILeanTween.rotateZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

---@param gameObject GameObject
---@param color Color
---@param time number
function LeanTween:color(gameObject, color, time)
    local uniqueId = APILeanTween.color(gameObject:GetInstanceID(), color:toTable(), time)
    return LTDescr.new(uniqueId)
end

---@param from number
---@param to number
---@param time number
---@param func function
function LeanTween:value(from, to, time, func)
    local uniqueId = APILeanTween.value(from, to, time, func)
    return LTDescr.new(uniqueId)
end

---@param gameObject GameObject
function LeanTween:cancel(gameObject)
    APILeanTween.cancel(gameObject:GetInstanceID())
end

function LeanTween:moveAnchore(gameObject, to, time)
    local uniqueId = APILeanTween.moveAnchore(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:delayCall(gameObject, delayTime, callback)
    local uniqueId = APILeanTween.delayCall(gameObject:GetInstanceID(), delayTime, callback)
    return LTDescr.new(uniqueId)
end