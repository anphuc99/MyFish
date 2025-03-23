---@class EnergyManager : MonoBehaviour
local EnergyManager = class("EnergyManager", MonoBehaviour)
EnergyManager.__path = __path
function EnergyManager:Awake()
    self.evOnSubtractBagItem = Event:Register(Constant.Event.OnSubtractBagItem, Lib.handler(self, self.UseEnergyItem))
end

function EnergyManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnSubtractBagItem, self.evOnSubtractBagItem)
end

function EnergyManager:UseEnergyItem(UID,resp)
    local type = DataManager.Instance:GetStallByUID(UID).type
    if type == Constant.StallType.Energy then
        local startPoint = Vector3.new(343, 95, 0)
        local endPoint
        local selectType
        selectType = ParticleManager.type.ENERGY
        endPoint = Vector3.new(-895, 178, 0)
        local amount = math.random(8,15)
        local curEnergy = Me:get_player():getEnergy() 
        local splitEnergy = (resp.data.energy_valueUpdate - curEnergy) / amount
        local numEnergy = 1
        ParticleManager.Instance:Spawn(selectType, startPoint, endPoint, amount, function ()
            self:UpdateEnergy(curEnergy + math.ceil(splitEnergy * numEnergy))
            numEnergy = numEnergy + 1
        end)
    end
end

function EnergyManager:UpdateEnergy(energy)    
    Me:get_player():update({energy_valueUpdate = energy})    
    PlayerInfomation.Instance:UpdateEnergy()
end

_G.EnergyManager = EnergyManager
