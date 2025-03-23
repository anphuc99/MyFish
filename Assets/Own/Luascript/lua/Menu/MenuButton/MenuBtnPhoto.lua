---@class MenuBtnPhoto : MenuButtonBase
local MenuBtnPhoto, base = class("MenuBtnPhoto", MenuButtonBase)
MenuBtnPhoto.__path = __path

function MenuBtnPhoto:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PhotoManager.Instance:OnPhotoMode()
end

_G.MenuBtnPhoto = MenuBtnPhoto