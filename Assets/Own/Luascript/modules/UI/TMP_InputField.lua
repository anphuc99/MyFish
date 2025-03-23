---@class TMP_InputField : Component
local TMP_InputField, base = class("TMP_InputField", Component)

function TMP_InputField:GetText()    
    return APITMP_InputField.GetText(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function TMP_InputField:SetText(text)    
    APITMP_InputField.SetText(text, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

_G.TMP_InputField = TMP_InputField