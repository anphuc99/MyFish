---@class FishThinking : MonoBehaviour
---@field thinking GameObject
---@field text TextMeshPro
---@field food GameObject
local FishThinking = class("FishThinking", MonoBehaviour)
FishThinking.__path = __path

function FishThinking:Awake()
    self.parent = self.transform:GetParent()
end

function FishThinking:OnDestroy()
    Time:stopTimer(self.timerID)
end

function FishThinking:Thinking(thinking)
    self.thinking:SetActive(true)
    self.text:SetText(thinking)
    self.timerID = Time:startTimer(5, function ()
        self.thinking:SetActive(false)
    end)
end

function FishThinking:Hungry()
    self.thinking:SetActive(false)
    self.food:SetActive(true)
end

function FishThinking:Full()
    self.food:SetActive(false)
end

function FishThinking:Update()
    local parentLocalScale = self.parent:GetLocalScale()
    local localScale = self.text.transform:GetLocalScale()
    if parentLocalScale.x < 0 then
        localScale.x = -math.abs(localScale.x)
        self.text.transform:SetLocalScale(localScale)
    else
        localScale.x = math.abs(localScale.x)
        self.text.transform:SetLocalScale(localScale)
    end
end

_G.FishThinking = FishThinking
