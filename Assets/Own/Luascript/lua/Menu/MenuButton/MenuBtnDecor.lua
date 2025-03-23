---@class MenuBtnDecor : MenuButtonBase
local MenuBtnDecor, base = class("MenuBtnDecor", MenuButtonBase)
MenuBtnDecor.__path = __path

function MenuBtnDecor:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    DecorManager.Instance:OnDecorMode()
end

_G.MenuBtnDecor = MenuBtnDecor