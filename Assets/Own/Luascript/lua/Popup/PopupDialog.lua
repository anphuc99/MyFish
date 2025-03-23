---@class PopupDialog : MonoBehaviour
---@field executer FSMC_Executer
---@field text TextMeshProGUI
---@field message Transform
local PopupDialog = class("PopupDialog", MonoBehaviour)
PopupDialog.__path = __path
function PopupDialog:OnBeginShow()
    self.message:SetLocalScale(Vector3.zero)
end

function PopupDialog:OnEndShow()
    self.texts = self.params.texts
    self.count = 0
    for index, value in pairs(self.texts) do
        self.count = self.count + 1
    end
    self.indexText = 1    
    self.executer:SetTrigger(Constant.StateManchine.Trigger.Show)
end

function PopupDialog:Controller()
    self.text:SetText("")
    if self.indexText <= self.count then
        self.executer.params.text = self.texts[tostring(self.indexText)]
        self.indexText = self.indexText + 1
        self.executer:SetTrigger(Constant.StateManchine.Trigger.Next)
    else
        self.executer:SetTrigger(Constant.StateManchine.Trigger.Hide)
    end
end

function PopupDialog:Click()
    self.executer:SetTrigger(Constant.StateManchine.Trigger.Next)
end

function PopupDialog:Hide()
    PopupManager:hide(self.PopupID)
end

function PopupDialog:OnEndHide()
    if self.params.onHide then
        self.params.onHide()
    end
end

_G.PopupDialog = PopupDialog
