
---@class MenuBtnRanking : MenuButtonBase
local MenuBtnRanking, base = class("MenuBtnRanking", MenuButtonBase)
MenuBtnRanking.__path = __path

function MenuBtnRanking:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    PopupManager:show(Constant.PoppupID.Popup_Ranking)
end

_G.MenuBtnRanking = MenuBtnRanking
