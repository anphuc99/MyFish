---@class TextRunAnimation : StateScriptable
local TextRunAnimation = class("TextRunAnimation", MonoBehaviour)
TextRunAnimation.__path = __path
---@param executer FSMC_Executer
function TextRunAnimation:OnStateEnter(executer)
    ---@type TextMeshProGUI
    self.textUI = executer.params.textUI
    self.text = executer.params.text
    local txt = self.text
    self.textUI:SetText("")    
    local txtLen = string.len(txt)
    local step = 1
    self.time = Time:startFramer(1, function ()
        self.textUI:SetText(string.sub(txt, 1, step))
        step = step + 1
        if step >= txtLen then
            executer:SetTrigger(Constant.StateManchine.Trigger.Next)
            return false    
        end
        return true
    end)
end
---@param executer FSMC_Executer
function TextRunAnimation:OnStateExit(executer)
    Time:stopFramer(self.time)
    self.textUI:SetText(self.text)
end

_G.TextRunAnimation = TextRunAnimation