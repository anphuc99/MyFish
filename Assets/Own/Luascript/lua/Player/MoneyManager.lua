
---@class MoneyManager : MonoBehaviour
---@field gold TextMeshProGUI
---@field gcoin TextMeshProGUI
---@field KC TextMeshProGUI
---@field energy TextMeshProGUI
---@field energyTime TextMeshProGUI
---@field energySlider Slider
---@field XPManager XPManager
---@field p PlayerInfomation
local MoneyManager = class("MoneyManager", MonoBehaviour)
MoneyManager.__path = __path

local g,gc,kc,eg,timedelta = 0,0,0,0,0

function MoneyManager:OnEnable()
    local player = Me:get_player()
    local data = player:get()
    self.g = data.currency_coin
    -- self.gc =self.p:getGCoin()
    -- self.kc = self.p:getKC()
    -- self.eg = self.p:getEnergy()
    -- self.timedelta = self.p:getTimerEnergy()

    ServerHandler:On("change_player", Lib.handler(self, self.UpdateMoney))

    -- local min, sec = (timedelta/60), (timedelta%60)

    self.gold:SetText(tostring(self.g))
    -- self.gcoin:SetText(tostring(self.gc))
    -- self.KC:SetText(tostring(self.kc))
    -- self.energy:SetText(tostring(self.eg))
    -- self.energyTime:SetText(string.format("%02d:%02d",min,sec))
    -- self.energySlider:SetValue((self.eg/150)*100)
    -- self:CooldownEnergy()
end

function MoneyManager:OnDisable()
    ServerHandler:Off("change_player")
end
    
function MoneyManager:OnDestroy()
    Time:stopFramer(self.timerID)
end


function MoneyManager:UpdateMoney(data)
    self.g = data.currency_coin
    self.p:setGold(self.g)
    self.gold:SetText(tostring(self.g))
   -- Lib.handler(self, self.ChangeGold(data.currency.coin))
end

function MoneyManager:AddCoin(coin)
    ServerHandler:SendMesseage("debug", { cmd = "add_coin", value = 1000 }, Lib.handler(self, self.test))
end

function MoneyManager:test(data)
    
end


function MoneyManager:ChangeGold(gold)
    --self.g = gold
    
    --self.p:setGold(self.g)
    --self.gold:SetText(tostring(self.g))
end

function MoneyManager:AddGCoin(gcoin)
    self.gc = self.gc + gcoin
    self.p:setGCoin(self.gc)
    self.gcoin:SetText(tostring(self.gc))
end

function MoneyManager:AddKC(kcuong)
    self.kc = self.kc + kcuong
    self.p:setKC(self.kc)
    self.KC:SetText(tostring(self.kc))
end

function MoneyManager:AddEnergy(energy)
    self.eg = self.eg + energy
    self.p:setEnergy(self.eg)
    self.xpbar:SmoothValue((self.eg/150)*100,0.5,10)
    self.energy:SetText(tostring(self.eg))
end

function MoneyManager:SubGold(gold)
    self.g =self.g - gold
    self.p:setGold(self.g)
    self.gold:SetText(tostring(self.g))
end

function MoneyManager:SubGCoin(gcoin)
    self.gc = self.gc - gcoin
    self.p:setGCoin(self.gc)
    self.gcoin:SetText(tostring(self.gc))
end

function MoneyManager:SubKC(kcuong)
    self.kc = self.kc - kcuong
    self.p:setKC(self.kc)
    self.KC:SetText(tostring(self.kc))
end

function MoneyManager:SubEnergy(energy)
    self.eg = self.eg - energy
    self.p:setEnergy(self.eg)
    self.energy:SetText(tostring(self.eg))
end

function MoneyManager:AddExp(xpgain)
    self.XPManager:gainXp(xpgain)
end

function MoneyManager:CooldownEnergy()
    self.timerID = Time:startTimer(1, function ()
        timedelta = self.p:getTimerEnergy() - 1
        local min, sec = (timedelta/60), (timedelta%60)
        self.energyTime:SetText(string.format("%02d:%02d",min,sec))
        self.p:setTimerEnergy(timedelta)
        return true
    end)
end


_G.MoneyManager = MoneyManager
