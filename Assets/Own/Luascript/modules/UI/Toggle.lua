---@class Toggle : Component
Toggle = class("Toggle", Component)

function Toggle:IsOn()
    return APIToggle.IsOn(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Toggle:SetOn(isOn)
    APIToggle.SetOn(self.gameObject:GetInstanceID(), self:GetInstanceID(), isOn)
end