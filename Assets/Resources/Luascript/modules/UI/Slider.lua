---@class Slider : Component
local Slider, base = class("Slider", Component)

function Slider:GetValue()
    return self.value
end

function Slider:SetValue(value)
    self.value = value
    Unity.UISetSliderValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:GetMinValue()
    return self.minValue
end

function Slider:SetMinValue(value)
    self.minValue = value
    Unity.UISetMinSliderValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:GetMaxValue()
    return self.maxValue    
end

function Slider:SetMaxValue(value)
    self.maxValue = value
    Unity.UISetMaxSliderValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:SmoothValue(toValue, time, leanTweenType, onComplete)
    Unity.UISmootSliderValue(self.gameObject:GetInstanceID(), self:GetInstanceID(), toValue, time, leanTweenType,onComplete)
end

rawset(_G, "Slider", Slider)