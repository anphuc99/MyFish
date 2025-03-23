
---@class MenuBtnShop : MenuButtonBase
local MenuBtnShop, base = class("MenuBtnShop", MenuButtonBase)
MenuBtnShop.__path = __path

function MenuBtnShop:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_Shop)
end

_G.MenuBtnShop = MenuBtnShop
