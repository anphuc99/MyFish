
---@class MenuBtnBreed : MenuButtonBase
local MenuBtnBreed, base = class("MenuBtnBreed", MenuButtonBase)
MenuBtnBreed.__path = __path

function MenuBtnBreed:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_Breed)
end

_G.MenuBtnBreed = MenuBtnBreed
