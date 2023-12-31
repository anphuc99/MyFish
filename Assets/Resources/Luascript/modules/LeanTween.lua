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
    Unity.ExecuteFunctionLTDescr(self.uniqueId,"setOnComplete", func)
end

function LTDescr:setEase(leanTweenType)
    Unity.ExecuteFunctionLTDescr(self.uniqueId, "setEase", leanTweenType)
end

---@class LeanTween
LeanTween = {}

---@param gameObject GameObject
---@param to Vector3
---@param time number
function LeanTween:move(gameObject, to, time)
    local uniqueId = Unity.LeanTweenMove(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocal(gameObject, to, time)
    local uniqueId = Unity.LeanTweenLocalMove(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scale(gameObject, to, time)
    local uniqueId = Unity.LeanTweenScale(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotate(gameObject, to, time)
    local uniqueId = Unity.LeanTweenRotate(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveX(gameObject, to, time)
    local uniqueId = Unity.LeanTweenMoveX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveY(gameObject, to, time)
    local uniqueId = Unity.LeanTweenMoveY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveZ(gameObject, to, time)
    local uniqueId = Unity.LeanTweenMoveZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocalX(gameObject, to, time)
    local uniqueId = Unity.LeanTweenLocalMoveX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocalY(gameObject, to, time)
    local uniqueId = Unity.LeanTweenLocalMoveY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:moveLocalZ(gameObject, to, time)
    local uniqueId = Unity.LeanTweenLocalMoveZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scaleX(gameObject, to, time)
    local uniqueId = Unity.LeanTweenScaleX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scaleY(gameObject, to, time)
    local uniqueId = Unity.LeanTweenScaleY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:scaleZ(gameObject, to, time)
    local uniqueId = Unity.LeanTweenScaleZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotateX(gameObject, to, time)
    local uniqueId = Unity.LeanTweenRotateX(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotateY(gameObject, to, time)
    local uniqueId = Unity.LeanTweenRotateY(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

function LeanTween:rotateZ(gameObject, to, time)
    local uniqueId = Unity.LeanTweenRotateZ(gameObject:GetInstanceID(), to, time)
    return LTDescr.new(uniqueId)
end

