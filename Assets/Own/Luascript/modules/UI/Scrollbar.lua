---@class Scrollbar : Component
local Scrollbar, base = class("Scrollbar", Component)

function Scrollbar:GetValue()
    return self.value
end

function Scrollbar:SetValue(value)
    self.value = value
    APIScrollbar.SetValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Scrollbar:SmoothValue(toValue, time, leanTweenType, onComplete)
    APIScrollbar.SmoothValue(self.gameObject:GetInstanceID(), self:GetInstanceID(), toValue, time, leanTweenType,onComplete)
end

_G.Scrollbar = Scrollbar