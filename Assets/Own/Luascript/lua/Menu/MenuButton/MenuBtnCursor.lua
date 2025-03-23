
---@class MenuBtnCursor : MenuButtonBase
local MenuBtnCursor, base = class("MenuBtnCursor", MenuButtonBase)
MenuBtnCursor.__path = __path

function MenuBtnCursor:BtnIsSelfClick()
    local isClick = self.isClick
    base.BtnIsSelfClick(self)
    if not isClick then
        self.icon.transform:SetLocalScale(Vector3.new(1.3, 1.3, 1.3))
        FishManager.Instance:setViewMode(true)
        isClick = true
    else
        self.icon.transform:SetLocalScale(Vector3.new(1, 1, 1))
        FishManager.Instance:setViewMode(false)
        isClick = false
    end 
    self.isClick = isClick   
end

function MenuBtnCursor:BtnOtherClick()
    base.BtnOtherClick(self)
    self.icon.transform:SetLocalScale(Vector3.new(1, 1, 1))
    FishManager.Instance:setViewMode(false)
end
_G.MenuBtnCursor = MenuBtnCursor
