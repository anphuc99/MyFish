---@class MenuBtnMission : MenuButtonBase
local MenuBtnMission, base = class("MenuBtnMission", MenuButtonBase)
MenuBtnMission.__path = __path

function MenuBtnMission:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_Quests)
end

_G.MenuBtnMission = MenuBtnMission
