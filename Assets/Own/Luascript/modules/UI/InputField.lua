---@class InputField : Component
local InputField, base = class("InputField", Component)

function InputField:GetText()    
    return APIInputField.GetText(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function InputField:SetText(text)    
    APIInputField.SetText(text, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

_G.InputField = InputField