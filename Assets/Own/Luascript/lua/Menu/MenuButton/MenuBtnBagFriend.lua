---@class MenuBtnBagFriend : MenuButtonBase
local MenuBtnBagFriend, base = class("MenuBtnBagFriend", MenuButtonBase)
MenuBtnBagFriend.__path = __path

function MenuBtnBagFriend:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_BagFriend)   
end

_G.MenuBtnBagFriend = MenuBtnBagFriend
