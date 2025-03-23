---@class TextAmount : MonoBehaviour
---@field text TextMeshProGUI
local TextAmount = class("TextAmount", MonoBehaviour)
TextAmount.__path = __path
function TextAmount:SetAmount(amount)
    self.text:SetText("+"..tostring(amount))
end

_G.TextAmount = TextAmount