---@class TextMeshPro : Component
local TextMeshPro, base = class("TextMeshPro", Component)

function TextMeshPro:GetText()
    return self.text
end

function TextMeshPro:SetText(text)
    self.text = text
    APITextMeshPro.SetText(text, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

---@param color Color
function TextMeshPro:SetColor(color)
    self.color = color
    APITextMeshPro.SetColor(color:toTable(), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function TextMeshPro:GetColor()
    return self.color
end

_G.TextMeshPro = TextMeshPro