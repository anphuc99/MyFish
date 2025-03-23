
---@class getCoinExp : MonoBehaviour
---@field value number
---@field Gold Sprite
---@field Exp Sprite
local getCoinExp = class("getCoinExp", MonoBehaviour)
getCoinExp.__path = "lua/getCoinExp.lua"

function getCoinExp:OnEnable()
    self.Move(self,1,100)
end

function getCoinExp:Move(type, val)
    --self.value = val;
    
    
    local actions = {
        [1] = function()
            --self.spriteRenderer:SetSprite(self.Gold)
            self:CoinMove()
        end,
        [2] = function()
           -- self.spriteRenderer:SetSprite(self.Exp)
           self:ExpMove()
        end,
    }

    local action = actions[type]
    if action then
        action()
    end
end

function getCoinExp:MoveObject(firstMove, secondMove, localMove, onComplete)
    LeanTween:move(self.gameObject, firstMove, 1):setOnComplete(function ()
        LeanTween:move(self.gameObject, secondMove, 3):setOnComplete(function ()
            if localMove then
                LeanTween:moveLocal(self.gameObject, localMove, 1.5)
                :setEase(LeanTweenType.easeInBack)
            end
            if onComplete then
                self.Destroy(self)
                onComplete()
            end
        end)
    end)
end

function getCoinExp:CoinMove()
    local pos = self.gameObject.transform:GetPosition()
    local firstMove = Vector3.new(pos.x - 0.5, pos.y + 1.5, pos.z)
    local secondMove = Vector3.new(firstMove.x - 0.3, firstMove.y -3, firstMove.z )
    local localMove = Vector3.new(-613,497,0)

    self:MoveObject(firstMove, secondMove, localMove, function()
        self.MenuManager:AddGold(self.value)
    end)
end

function getCoinExp:ExpMove()
    local pos = self.gameObject.transform:GetPosition()
    local firstMove = Vector3.new(pos.x - 0.5, pos.y + 1.5, pos.z)
    local secondMove = Vector3.new(firstMove.x - 0.3, firstMove.y -3, firstMove.z )

    self:MoveObject(firstMove, secondMove, nil, function()
        self.MenuManager:AddExp(self.value)
    end)
end

return getCoinExp
