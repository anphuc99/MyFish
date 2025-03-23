
---@class MenuBtnMail : MenuButtonBase
local MenuBtnMail, base = class("MenuBtnMail", MenuButtonBase)
MenuBtnMail.__path = __path

function MenuBtnMail:Start()
    self:SetNotify()
end

function MenuBtnMail:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_Email)   
end

function MenuBtnMail:SetNotify()
    local countMail = 0
    local mail = Me:get_mails()
    for key, value in pairs(mail) do
        countMail = countMail + 1
    end

    if countMail == 0 then
        self.notify:SetActive(false)
    else
        self.notify:SetActive(true)
    end
end

_G.MenuBtnMail = MenuBtnMail
