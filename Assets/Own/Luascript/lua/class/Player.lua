---@class Player
local Player = class("Player")
--[[
    ["properties"] = {
        [ "UUID" ],
        [ "name" ],
        [ "gender" ],
        [ "lv_level" ],
        [ "lv_exp" ],
        [ "lv_maxExp" ],
        [ "energy_lastUpdate" ],
        [ "energy_valueUpdate" ],
        [ "energy_maxEnergy" ],
        [ "energy_enerRecovery" ],
        [ "currency_coingy" ],
        [ "currency_point" ],
        [ "currency_diamond" ],
        [ "bag" ]
        [ "bag_maxSlot" ],
        [ "server" ],
        ["friend_code"]
    },
]]
function Player:ctor(properties)
    self.UUID = properties.UUID
    self.properties = properties
    self.attributes = {}
    self.evPlayer = Event:Register(Constant.Event.ServerChangePlayer, Lib.handler(self, self.SignalPlayerChange))
end

-- Lấy cập nhập thông tin Player
function Player:update(any)
    if type(any) == "table" then
        for k, v in pairs(any) do
            self.properties[k] = v
        end
    end
end

---@return any
-- Lấy thông tin Player
function Player:get()
    return self.properties
end

function Player:getEnergy()
    local energy_valueUpdate = self.properties.energy_valueUpdate
    local energy_energyRecovery = self.properties.energy_energyRecovery
    local energy_lastUpdate = self.properties.energy_lastUpdate
    local energy_maxEnergy = self.properties.energy_maxEnergy
    local last_update_s = math.ceil(energy_lastUpdate / 1000)
    local recoveryRate = 1 / (energy_energyRecovery * 60)
    local now = os.time()
    local timeDiff = now - last_update_s
    local recoveredPoint = math.floor(timeDiff * recoveryRate)
    local currentPoint = math.min(energy_maxEnergy, energy_valueUpdate + recoveredPoint)
    return math.min(currentPoint, energy_maxEnergy)
end

function Player:set(key, value)
    self.properties[key] = value
end

-- Tạo biến cục bộ cho Player
function Player:setData(key, value)
    self.attributes[tostring(key)] = value
end

---@return any
-- Lấy biến cục bộ cho Player
function Player:getData(key)
    return self.attributes[tostring(key)]
end

function Player:SignalPlayerChange(data)
    if Me.other then
        return
    end
    local lastLevel = Me:get_player():get().lv_level
    for k, v in pairs(data) do
        if k == "lv_level" and self.properties["lv_level"] ~= v then
            PopupManager:show(Constant.PoppupID.Popup_LevelUp,{lv=v})
            ShopManager.Instance:HandleBlockDecorationAfterLevelUp(v, lastLevel)
        end
        if k == "fish_open" and self.properties["fish_open"] ~= v then
            ShopManager.Instance:HandleBlockFishAfterLevelUp(v)
        end
    end
    self:update(data)
    for k, v in pairs(data) do
        Event:Emit(k)
    end
end

---@return Sprite
function Player:GetSpriteAvatar(callback, callbackError)
    Sprite:CreateSpriteFromURL(self:get().avatar, function (spr)        
        callback(spr)
    end, function ()
        if callbackError then
            callbackError()
        end
    end)
end

function Player:Remove()
    Event:UnRegister(Constant.Event.ServerChangePlayer, self.evPlayer)
end

_G.Player = Player
