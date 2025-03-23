---@class BarHelper : MonoBehaviour
---@field maxValue number
---@field value number
---@field backgound SpriteRenderer
---@field bar SpriteRenderer
local BarHelper = class("BarHelper", MonoBehaviour)
BarHelper.__path = __path

function BarHelper:Awake()
    self:SetValue(self.value)
end

function BarHelper:GetValue()
    return self.value
end

function BarHelper:SetValue(value)
    self.value = value
    local sizeBG = self.backgound:GetSize()
    self.bar:SetSize(Vector3.new(value/self.maxValue * sizeBG.x, sizeBG.y, sizeBG.z))
end

_G.BarHelper = BarHelper
