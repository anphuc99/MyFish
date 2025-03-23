
---@class PlayerManager : MonoBehaviour
---@field playerInfomation PlayerInfomation
---@field foodFish GameObject
local PlayerManager = class("PlayerManager", MonoBehaviour)
PlayerManager.__path = __path
function PlayerManager:Awake()
    PlayerManager.Instance = self
    Event:RegisterRequestData("ReqPlayerBuyFish", Lib.handler(self, self.BuyFish))
    -- self.eventID1 = Event:Register("MOUSE_DOWN", Lib.handler(self, self.FeedFish))
end

function PlayerManager:OnDestroy()
    Event:RemoveRequestData("ReqPlayerBuyFish")
    -- Event:UnRegister("MOUSE_DOWN", self.eventID1)
end

function PlayerManager:BuyFish(params, callback)    
    if params.price >= self.playerInfomation:getGCoin() then      
        ServerHandler:SendMessage("fish_shop", params.params, function (data)
            callback(params.params.data.UID, data)
        end)
    else
        callback(0,{code = 5})
    end
    -- callback(params.params.data.UID,{code = 0})
end

local randomPosFeed = {
    x = {-2.6, 4},
    y = 2.18
}

function PlayerManager:FeedFish()     
        local rdpos = math.Random(randomPosFeed.x[1], randomPosFeed.x[2])
        local pos = Vector3.new(rdpos, randomPosFeed.y, 0)
        for i = 1, 5, 1 do            
            local pos2 = pos
            pos2.x = pos.x + math.Random(-1,1)
            pos2.y = pos.y + math.Random(0,-0.5)
            ---@type GameObject
            local food = self:Instantiate(self.foodFish)
            food.transform:SetPosition(pos)
            LeanTween:move(food, pos + Vector3.new(0,-10,0), 20):setOnComplete(function ()
                self:Destroy(food)
            end)
            Event:Emit(Constant.Event.FeedFish, food) 
        end

end

function PlayerManager:StartEating()
    self:FeedFish()
end

_G.PlayerManager = PlayerManager
