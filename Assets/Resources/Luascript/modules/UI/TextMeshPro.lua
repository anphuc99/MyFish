---@class TextMeshPro : Component
local TextMeshPro, base = class("TextMeshPro", Component)

function TextMeshPro:GetText()
    return self.text
end

function TextMeshPro:SetText(text)
    self.text = text
    Unity.UISetTextMeshPro(text, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

rawset(_G, "TextMeshPro", TextMeshPro)