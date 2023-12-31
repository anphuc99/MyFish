---@class Scrollbar : Component
local Scrollbar, base = class("Scrollbar", Component)

function Scrollbar:GetValue()
    return self.value
end

function Scrollbar:SetValue(value)
    self.value = value
    Unity.UIScrollBarSetValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Scrollbar:SmoothValue(toValue, time, leanTweenType, onComplete)
    Unity.UISmootScrollBaValue(self.gameObject:GetInstanceID(), self:GetInstanceID(), toValue, time, leanTweenType,onComplete)
end

rawset(_G, "Scrollbar", Scrollbar)