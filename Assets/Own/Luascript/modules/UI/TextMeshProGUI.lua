---@class TextMeshProGUI : Component
local TextMeshProGUI, base = class("TextMeshProGUI", Component)

function TextMeshProGUI:GetText()
    return self.text
end

function TextMeshProGUI:SetText(text)
    self.text = text
    APITextMeshProGUI.SetText(tostring(text), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

---@param color Color
function TextMeshProGUI:SetColor(color)
    self.color = color
    APITextMeshProGUI.SetColor(color:toTable(), self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function TextMeshProGUI:GetColor()
    return self.color
end

_G.TextMeshProGUI = TextMeshProGUI