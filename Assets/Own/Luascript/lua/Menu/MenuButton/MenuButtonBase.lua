---@class MenuButtonBase : MonoBehaviour
---@field menuManager MenuManager
---@field name string
---@field btn Button
---@field icon Image
---@field notify GameObject
local MenuButtonBase = class("MenuButtonBase", MonoBehaviour)
MenuButtonBase.__path = __path

function MenuButtonBase:Awake()
    self.btn:onClickAddListener(Lib.handler(self, self.BtnClick))
    self.menuManager:AddListenerOnClick(Lib.handler(self, self.OnMenuBtnClick))
    self.evUpdateNotify = Event:Register(Constant.Event.UpdateNotify, Lib.handler(self, self.UpdateNotify))
end

function MenuButtonBase:OnDestroy()
    Event:UnRegister(Constant.Event.UpdateNotify, self.evUpdateNotify)
end

function MenuButtonBase:BtnClick()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self.menuManager:OnBtnMenuClick(self)
end

function MenuButtonBase:OnMenuBtnClick(btn)
    if self == btn then
        self:BtnIsSelfClick()
    else
        self:BtnOtherClick()
    end
end

function MenuButtonBase:BtnIsSelfClick()
    self.isClick = true
end

function MenuButtonBase:BtnOtherClick()
    self.isClick = false
end

function MenuButtonBase:UpdateNotify(notify)
    if notify == self.name then
        self:SetNotify()        
    end
end

function MenuButtonBase:SetNotify()

end

_G.MenuButtonBase = MenuButtonBase
