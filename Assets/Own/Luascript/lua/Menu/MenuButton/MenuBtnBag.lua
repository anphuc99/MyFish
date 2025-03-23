---@class MenuBtnBag : MenuButtonBase
local MenuBtnBag, base = class("MenuBtnBag", MenuButtonBase)
MenuBtnBag.__path = __path

function MenuBtnBag:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_Bag)   
end

_G.MenuBtnBag = MenuBtnBag
