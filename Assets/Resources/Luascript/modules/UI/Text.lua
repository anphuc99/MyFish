---@class Text : Component
local Text, base = class("Text", Component)

function Text:GetText()
    return self.text
end

function Text:SetText(text)
    self.text = text
    Unity.UISetText(text, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

rawset(_G, "Text", Text)