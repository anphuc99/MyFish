---@class ScaleAnimation : StateScriptable
---@field min Vector3
---@field max Vector3
---@field time number
---@field ease string
local ScaleAnimation = class("ScaleAnimation", MonoBehaviour)
ScaleAnimation.__path = __path
---@param executer FSMC_Executer
function ScaleAnimation:OnStateEnter(executer)
    self.gameObject = executer.params.GameObject
    self.transform = executer.params.GameObject.transform
    self.transform:SetLocalScale(self.min)
    self.tween = LeanTween:scale(self.gameObject, self.max, self.time):setEase(LeanTweenType[self.ease]):setOnComplete(function ()
        executer:SetTrigger(Constant.StateManchine.Trigger.Next)
    end)
end
---@param executer FSMC_Executer
function ScaleAnimation:OnStateExit(executer)
    self.tween:cancel()
    self.transform:SetLocalScale(self.max)
end
_G.ScaleAnimation = ScaleAnimation
