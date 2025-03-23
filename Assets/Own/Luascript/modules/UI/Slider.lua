---@class Slider : Component
local Slider, base = class("Slider", Component)

function Slider:GetValue()
    return APISlider.GetValue(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:SetValue(value)
    self.value = value
    APISlider.SetValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:GetMinValue()
    return self.minValue
end

function Slider:SetMinValue(value)
    self.minValue = value
    APISlider.SetMinValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:GetMaxValue()
    return self.maxValue    
end

function Slider:SetMaxValue(value)
    self.maxValue = value
    APISlider.SetMaxValue(value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Slider:SmoothValue(toValue, time, leanTweenType, onComplete)
    APISlider.SmoothValue(self.gameObject:GetInstanceID(), self:GetInstanceID(), toValue, time, leanTweenType,onComplete)
end

_G.Slider = Slider