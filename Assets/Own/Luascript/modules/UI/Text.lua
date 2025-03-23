---@class Text : Component
local Text, base = class("Text", Component)

function Text:GetText()
    return self.text
end

function Text:SetText(text)
    self.text = text
    APIText.SetText(text, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

_G.Text = Text