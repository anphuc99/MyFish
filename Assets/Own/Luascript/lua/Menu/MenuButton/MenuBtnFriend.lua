
---@class MenuBtnFriend : MenuButtonBase
local MenuBtnFriend, base = class("MenuBtnFriend", MenuButtonBase)
MenuBtnFriend.__path = __path

function MenuBtnFriend:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    FriendListManager.Instance:Toggle()
end

_G.MenuBtnFriend = MenuBtnFriend
