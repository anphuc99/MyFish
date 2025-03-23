---@class AquariumBonus : MonoBehaviour
---@field coinBonus TextMeshProGUI
---@field expBonus TextMeshProGUI
local AquariumBonus = class("AquariumBonus", MonoBehaviour)
AquariumBonus.__path = __path

function AquariumBonus:Awake()
    AquariumBonus.Instance = self
    self.bonus = {}
    self.eventID = Event:Register(Constant.Event.OnAddDecorItem, Lib.handler(self, self.RemoveDeco))
    self.eventID2 = Event:Register(Constant.Event.OnSubtractDecorItem, Lib.handler(self, self.AddDeco))
    self.eventID3 = Event:Register(Constant.Event.OnChangeAquarium, Lib.handler(self, self.OnChangeAquarium))
end

function AquariumBonus:OnDestroy()
    Event:UnRegister(Constant.Event.OnAddDecorItem, self.eventID)
    Event:UnRegister(Constant.Event.OnSubtractDecorItem, self.eventID2)
    Event:UnRegister(Constant.Event.OnChangeAquarium, self.eventID3)
end

function AquariumBonus:Start()
    DecoMaster.getOnServer(function (resp)
        if resp.code == 1 then
            self:GetBonus(1, function(resp)
                self:ShowBonus(1)
            end)            
        end
    end)
    
end

function AquariumBonus:GetBonus(aquariumID, callback)
    if(self.bonus[tostring(aquariumID)]) then
        if(callback) then
            callback(self.bonus[tostring(aquariumID)])
        end
        return self.bonus[tostring(aquariumID)]
    end
    local bonus = {
        coin = 0,
        exp = 0
    }
    AquariumSocket:GetDecorations(aquariumID, function (resp)
        for k, v in pairs(resp) do
            local UID = v["UID"]
            local decoBonus = DecoMaster.getBonusByUID(UID)
            bonus.coin = bonus.coin+decoBonus.coin
            bonus.exp = bonus.exp+decoBonus.exp
        end
        self.bonus[tostring(aquariumID)] = bonus
        self:SetBonus(aquariumID)
        if(callback) then
            callback(self.bonus[tostring(aquariumID)])
        end
    end)
end


--opt = 1 là xóa Deco, số khác là thêm Deco
--dùng ENUM
function AquariumBonus:AddOrRemoveDeco(DecoID, opt, AquaID)
    local decoBonus = DecoMaster.getBonusByUID(DecoID)
    local currentAquarium = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1
    local aquaBonus = self.bonus[tostring(currentAquarium)]
    if(AquaID ~= nil) then
       aquaBonus = self.bonus[tostring(AquaID)]
    end
    if(opt == 1) then
        aquaBonus.coin = aquaBonus.coin - decoBonus.coin
        aquaBonus.exp = aquaBonus.exp - decoBonus.exp
    else 
        aquaBonus.coin = aquaBonus.coin + decoBonus.coin
        aquaBonus.exp = aquaBonus.exp + decoBonus.exp
    end
    self:SetBonus(aquaBonus, AquaID)
    local currentAquarium = currentAquarium
    if(currentAquarium == AquaID or AquaID == nil) then
        self:ShowBonus(currentAquarium)
    end
end

function AquariumBonus:AddDeco(DecoID, AquaID)
    self:AddOrRemoveDeco(DecoID, Enum.BONUS.ADD, AquaID)
end

function AquariumBonus:RemoveDeco(DecoID, AquaID)
    self:AddOrRemoveDeco(DecoID, Enum.BONUS.DELETE, AquaID)
end

function AquariumBonus:ShowBonus(aquariumID)
    local aquaBonus = self.bonus[tostring(aquariumID)]
    local coinBonus = aquaBonus.coin
    local expBonus = aquaBonus.exp
    self.coinBonus:SetText(tostring(coinBonus).."%")
    self.expBonus:SetText(tostring(expBonus).."%")
    -- body
end

function AquariumBonus:PrintBonus()
    Lib.pv(self.bonus)
end

function AquariumBonus:SetBonus(data, aquariumID)
    self.bonus[tostring(aquariumID)] = data
end

function AquariumBonus:OnChangeAquarium(AquaID)
    self:ShowBonus(AquaID)
    
end


_G.AquariumBonus = AquariumBonus