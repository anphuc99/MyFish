
---@class MenuBtnFood : MenuButtonBase
local MenuBtnFood, base = class("MenuBtnFood", MenuButtonBase)
MenuBtnFood.__path = __path

function MenuBtnFood:BtnIsSelfClick()
    base.BtnIsSelfClick(self)
    FoodManager.Instance:HandleFood()
end

_G.MenuBtnFood = MenuBtnFood
