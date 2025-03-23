---@class ParticleManager : MonoBehaviour
---@field prefabs table
---@field parent Transform
local ParticleManager = class("ParticleManager", MonoBehaviour)
ParticleManager.__path = __path

ParticleManager.type =
{
    ENERGY = "energy"
}

local normalSize = Vector3.new(0.8, 0.8, 0.8)
local hideSize = Vector3.new(0, 0, 0)

function ParticleManager:Awake()
    ParticleManager.Instance = self
end

---@param type string
---@param startPoint Vector3
---@param endPoint Vector3
---@param amount number
---@param onEndMove function
function ParticleManager:Spawn(type, startPoint, endPoint, amount, onEndMove)    
    local delay = 0
    for i = 1, amount, 1 do
        self:PerformAction(type, startPoint, endPoint, delay, onEndMove)
        delay = delay + 0.06
    end
end

function ParticleManager:PerformAction(type, startPoint, endPoint, delay, onEndMove)
    local distanceX = math.random(-80, 80)
    local distanceY = math.random(-30, 30)
    local start = Vector3.new(startPoint.x + distanceX, startPoint.y + distanceY, 0)

    local selectType = self:SelectType(type)
    local item = self:Instantiate(selectType)

    item.transform:SetPosition(start)
    item.transform:SetParent(self.parent)

    Time:startTimer(delay, function ()
        LeanTween:scale(item, normalSize, 0.26):setEase(LeanTweenType.easeOutBack)
    end)

    Time:startTimer(delay + 0.46, function ()
        LeanTween:moveLocal(item, endPoint, 0.76):setEase(LeanTweenType.easeInBack)
    end)

    Time:startTimer(delay + 1, function ()
        LeanTween:scale(item, hideSize, 0.26):setEase(LeanTweenType.easeOutBack)
        :setOnComplete
        (
            function ()
                if onEndMove then
                    onEndMove()                    
                end
                self:Destroy(item)
            end
        )
    end)
end

function ParticleManager:SelectType(type)
    if type == ParticleManager.type.ENERGY then
        return self.prefabs.energy
    end
end

_G.ParticleManager = ParticleManager