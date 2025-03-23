---@class PlayerInfomation : MonoBehaviour
---@field CreateUser GameObject
---@field NameText TextMeshProGUI
---@field currency_coin TextMeshProGUI
---@field currency_point TextMeshProGUI
---@field currency_diamond TextMeshProGUI
---@field energy TextMeshProGUI
---@field energy_time TextMeshProGUI
---@field energy_bar Slider
---@field level TextMeshProGUI
---@field exp_bar Slider
---@field avatar Image
---@field fishCount TextMeshProGUI
---@field posUICurrency table
local PlayerInfomation = class("PlayerInfomation", MonoBehaviour)
PlayerInfomation.__path = __path
local MaxSizeBar=139
local function formatCurrency(amount)
    local formattedAmount = tostring(amount)
    formattedAmount = string.reverse(formattedAmount)
    formattedAmount = string.gsub(formattedAmount, "(%d%d%d)", "%1,")
    formattedAmount = string.reverse(formattedAmount)
    formattedAmount = string.gsub(formattedAmount, "^,", "")
    return formattedAmount
end

function PlayerInfomation:Awake()
    PlayerInfomation.Instance = self
    self.evUpdateInfoMoney1 = Event:Register(Constant.Event.CurrencyCoin, Lib.handler(self, self.UpdateInfoMoney))
    self.evUpdateInfoMoney2 = Event:Register(Constant.Event.CurrencyPoint, Lib.handler(self, self.UpdateInfoMoney))
    self.evUpdateInfoMoney3 = Event:Register(Constant.Event.CurrencyDiamond, Lib.handler(self, self.UpdateInfoMoney))
    self.evUpdateEnergy=Event:Register(Constant.Event.CurrencyEnergy,Lib.handler(self, self.UpdateEnergy))
    self.evUpdateLevel = Event:Register(Constant.Event.LvLevel, Lib.handler(self, self.UpdateLevel))
    self.evUpdateExp = Event:Register(Constant.Event.LvExp, Lib.handler(self, self.UpdateExp))
    self.evAvatar = Event:Register(Constant.Event.Avatar, Lib.handler(self, self.UpdateAvatar))
    self.evUpdateFishCount = Event:Register(Constant.Event.UpdateFishCount, Lib.handler(self, self.UpdateFishCount))
end

function PlayerInfomation:OnDestroy()
    Event:UnRegister(Constant.Event.CurrencyCoin, self.evUpdateInfoMoney1)
    Event:UnRegister(Constant.Event.CurrencyPoint, self.evUpdateInfoMoney2)
    Event:UnRegister(Constant.Event.CurrencyDiamond, self.evUpdateInfoMoney3)
    Event:UnRegister(Constant.Event.LvLevel, self.evUpdateLevel)
    Event:UnRegister(Constant.Event.LvExp, self.evUpdateExp)
    Event:UnRegister(Constant.Event.CurrencyEnergy,self.evUpdateEnergy)
    Event:UnRegister(Constant.Event.Avatar,self.evAvatar)
    Event:UnRegister(Constant.Event.UpdateFishCount, self.evUpdateFishCount)
    Time:stopTimer(self.timerID)
end

function PlayerInfomation:Start()
    self:CheckPlayer()
    -- ServerHandler:On("change_player", Lib.handler(self, self.UpdateMoney))
    
end

-- function PlayerInfomation:OnDisable()
--     ServerHandler:Off("change_player")
-- end


-- function PlayerInfomation:UpdateMoney(data)
--     self.Gold = data.currency.coin
--     self.currency_gold:SetText(tostring(self.Gold))
-- end

function PlayerInfomation:CheckPlayer()
    local LocalPlayer = Me:get_player()
    if (LocalPlayer == -1) then
        self.CreateUser:SetActive(true)
    else
        self:UpdatePlayerInfomation()
    end
end

-- hàm này dùng để cập nhật dữ liệu cho class PlayerInfomation
function PlayerInfomation:UpdatePlayerInfomation()
    self:UpdateName()
    self:UpdateInfoMoney()
    self:UpdateEnergy()
    self:CooldownEnergy()
    self:UpdateLevel()
    self:UpdateExp()
    self:UpdateAvatar()
    -- self:UpdateInfoLevel()
end

-- function PlayerInfomation:UpdateInfoLevel()
--     self.xptext:SetText(tostring(self.Exp))
--     self.leveltext:SetText(tostring(self.Level))
--     self.xpbar:SetValue((self.Exp/self.totalExp)*100)
-- end

function PlayerInfomation:UpdateName()
    if self.NameText then
        local LocalPlayer = Me:get_player()
        local data = LocalPlayer:get()
        self.NameText:SetText(data.name)
    end
end

function PlayerInfomation:UpdateInfoMoney()
    local LocalPlayer = Me:get_player()
    local data = LocalPlayer:get()
    self.currency_coin:SetText(formatCurrency(data.currency_coin))
    self.currency_point:SetText(formatCurrency(data.currency_point))
    self.currency_diamond:SetText(formatCurrency(data.currency_diamond))
end
function PlayerInfomation:UpdateLevel()
    local LocalPlayer = Me:get_player()
    local data = LocalPlayer:get()
    self.level:SetText(formatCurrency(data.lv_level))
end
function PlayerInfomation:UpdateExp()
    local LocalPlayer = Me:get_player()
    local data = LocalPlayer:get()
    self.exp_bar:SetValue(data.lv_exp/data.lv_maxExp)
end

function PlayerInfomation:UpdateAvatar()
    print("ddddddddddd")
    local localPlayer = Me:get_player()
    localPlayer:GetSpriteAvatar(function (spr)        
        self.avatar:SetSprite(spr)
    end)
end

function PlayerInfomation:UpdateEnergy()
    local LocalPlayer = Me:get_player()
    self.energy_bar:SetValue(LocalPlayer:getEnergy()/100)
    self.energy:SetText(LocalPlayer:getEnergy())
end

function PlayerInfomation:CooldownEnergy()
    local LocalPlayer = Me:get_player()
    local data = LocalPlayer:get()
    local value_enegry =LocalPlayer:getEnergy()
    local time_full_s = (data.energy_maxEnergy - math.min(value_enegry, data.energy_maxEnergy)) *(data.energy_energyRecovery) * 60
    if time_full_s > 0 then
        local min, sec = (time_full_s / 60), (time_full_s % 60)
        self.energy_time:SetText(string.format("%02d:%02d", min, sec))
    else
        self.energy_time:SetText("Đầy")
    end
    self.timerID = Time:startTimer(1, function()
        if time_full_s > 0 then
            time_full_s = time_full_s - 1
            local min, sec = (time_full_s / 60), (time_full_s % 60)
            if sec==0 then
               self:UpdateEnergy()
            end
            self.energy_time:SetText(string.format("%02d:%02d", min, sec))
        else
            self.energy_time:SetText("Đầy")
        end

        return true
    end)
end

function PlayerInfomation:OpenProfile()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:show(Constant.PoppupID.Popup_profile)
end

function PlayerInfomation:OpenPurchase()
    PopupManager:show(Constant.PoppupID.Popup_Purchase_GPoint)
end

function PlayerInfomation:UpdateFishCount()
    -- Set current aquarium here
    local currentAquarium = 1
    local data = Me:get_fish_by_index(currentAquarium)
    local count = 0
    for index, value in pairs(data) do
        count = count + 1
    end
    local aquarium = Me:get_aquarium()
    local max_slot = aquarium[currentAquarium].inform.properties.max_slot
    self.fishCount:SetText(count .. "/" .. max_slot)
end

function PlayerInfomation:GetPosUICurrency(UUID)
    return self.posUICurrency[UUID..""]
end

function PlayerInfomation:OpenExchangeDiamond()
    PopupManager:show(Constant.PoppupID.Popup_ExchangeDiamond, {
        data = Me:GetCurrencyPointToDimond()
    })
end

function PlayerInfomation:OpenExchangeGold()
    PopupManager:show(Constant.PoppupID.Popup_ExchangeGold, {
        data = Me:GetCurrencyPointToGold()
    })
end

-- function PlayerInfomation:setExp(exp)
--     self.Exp = exp
-- end

-- function PlayerInfomation:setTotalExp(totalExp)
--     self.totalExp = totalExp
-- end

-- function PlayerInfomation:setLevel(level)
--     self.Level = level
-- end

-- function PlayerInfomation:setGold(gold)
--     self.Gold = gold
-- end

-- function PlayerInfomation:setGCoin(gcoin)
--     self.GCoin = gcoin
-- end

-- function PlayerInfomation:setKC(kc)
--     self.KC = kc
-- end

-- function PlayerInfomation:setEnergy(energy)
--     self.Energy = energy
-- end



_G.PlayerInfomation = PlayerInfomation
