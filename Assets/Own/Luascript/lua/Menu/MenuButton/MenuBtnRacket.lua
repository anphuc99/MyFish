---@class MenuBtnRacket : MenuButtonBase
local MenuBtnRacket, base = class("MenuBtnRacket", MenuButtonBase)
MenuBtnRacket.__path = __path

function MenuBtnRacket:BtnIsSelfClick()
    local isClick = self.isClick
    if self.clicked == nil then
        self.clicked = true
        self.click = 0
    end
    base.BtnIsSelfClick(self)
    if not isClick then
        self.icon.transform:SetLocalScale(Vector3.new(1.3, 1.3, 1.3))
        FishManager.Instance:setSellMode(true)
        isClick = true
    else
        self.icon.transform:SetLocalScale(Vector3.new(1, 1, 1))
        FishManager.Instance:setSellMode(false)
        isClick = false
    end
    self.isClick = isClick

    self.click = self.click + 1
    if self.clicked then
        self.clicked = false
        Time:startTimer(0.2, function()
            if self.click >= 2 then
                Event:Emit(Constant.Event.SellAdultFish)
            end
            self.click = 0
            self.clicked = true
        end)
    end
end

function MenuBtnRacket:BtnOtherClick()
    base.BtnOtherClick(self)
    self.icon.transform:SetLocalScale(Vector3.new(1, 1, 1))
    FishManager.Instance:setSellMode(false)
end

_G.MenuBtnRacket = MenuBtnRacket
