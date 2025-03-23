---@class Fish : MonoBehaviour
---@field executer FSMC_Executer
---@field moveToTarget MoveToTarget
---@field bar BarHelper
local Fish = class("Fish", MonoBehaviour)
Fish.__path = __path

local pool = { xRight = 8, xLeft = -8, yUp = 0.52, yDown = -4.34 }

function Fish:Awake()
    self.foods = {}
    self.eventID1 = Event:Register(Constant.Event.FeedFish, Lib.handler(self, self.OnFeedFish))
end

function Fish:OnDestroy()
    Event:UnRegister(Constant.Event.FeedFish, self.eventID1)
    self.tween:cancel()
    Time:stopTimer(self.timeBar)
end

function Fish:Start()
    Event:RequestData(Constant.Request.Pos.ZoneFishLeft, nil, function(pos)
        pool.xLeft = pos.x
    end)
    Event:RequestData(Constant.Request.Pos.ZoneFishRight, nil, function(pos)
        pool.xRight = pos.x
    end)
    local localScale = self.transform:GetLocalScale()
    if math.random(0, 100) % 2 == 0 then
        localScale.x = -math.abs(localScale.x)
    else
        localScale.x = math.abs(localScale.x)
    end
    self.transform:SetLocalScale(localScale)

    local yPosition = (self.transform:GetPosition().y - 5) / (-2 / 3)
    local waterLevel = 3.25
    local timeSpawnToWater = (self.transform:GetPosition().y - waterLevel) / 10
    local timeWaterToPoint = (waterLevel - yPosition) * 140 / 100

    self.tween = LeanTween:moveY(self.gameObject, waterLevel, timeSpawnToWater)
        :setEase(LeanTweenType.easeInQuad)
        :setOnComplete
        (
            function()
                local obj = FishManager.Instance:ShowParticle(self.transform:GetPosition())

                self.tween = LeanTween:moveY(self.gameObject, yPosition, timeWaterToPoint)
                    :setEase(LeanTweenType.easeOutBack)
                    :setOnComplete
                    (
                        function()
                            FishManager.Instance:RemoveParticle(obj)
                            self.executer:SetTrigger(Constant.StateManchine.Trigger.OnSwin)
                        end
                    )
            end
        )
end

function Fish:SetData(properties, classFish, isAdult)
    if classFish and not self.FishClass then
        self.FishClass = classFish
        self.isAdult = isAdult and true or false
    end
    for k, v in pairs(properties) do
        self[tostring(k)] = v
    end
    -- self.id = data.id
    -- self.UID = data.UID
    -- self.gender = data.gender
    -- self.level = data.level
    -- self.bonus = data.bonus
    -- self.hungry = data.hungry
    -- self.hungry_empty = data.hungry_empty
    -- self.hungry_full = data.hungry_full
    -- self.time_remaning = data.time_remaning
    -- self.grow_up = data.grow_up
end

function Fish:Swim()
    local x = math.random(pool.xRight, pool.xLeft)
    local y = math.random(pool.yUp, pool.yDown)
    local endPoint = Vector3.new(x, y, 0)
    local localScale = self.transform:GetLocalScale()
    local position = self.transform:GetPosition()
    if position.x > x then
        localScale.x = -math.abs(localScale.x)
    elseif position.x < x then
        localScale.x = math.abs(localScale.x)
    end
    self.transform:SetLocalScale(localScale)
    self.tween = LeanTween:move(self.gameObject, endPoint, 3 + math.random() * 3):setOnComplete(function()
        self:Swim()
    end)
end

function Fish:StopSwin()
    self.tween:cancel()
end

---@param food FoodItem
function Fish:OnFeedFish(food)
    table.insert(self.foods, food)
    local fishModel = Me:get_fish_by_id(self.id)
    if fishModel:getScaleHungryTimeSlide() <= 0.1 then
        self.executer:SetBool(Constant.StateManchine.Bool.OnFeed, false)
    else
        self.executer:SetBool(Constant.StateManchine.Bool.OnFeed, true)
    end
end

function Fish:Feed()
    if #self.foods ~= 0 then
        local foodIndex = math.random(1, #self.foods)
        ---@type FoodItem
        local food = self.foods[foodIndex]
        self.moveToTarget:SetTargetObject(food.gameObject, self.gameObject, 3, function(rs)
            if not rs then
                table.remove(self.foods, foodIndex)
                self:Feed()
            else
                self:Destroy(food.gameObject)
                table.remove(self.foods, foodIndex)
                self.food = food
                self.executer:SetTrigger(Constant.StateManchine.Trigger.OnAte)

                --xac suat nhan duoc coin va exp
                -- local isLucky = 1
                -- local lucky = math.random()
                -- print(isLucky, lucky)
                -- if (lucky <= isLucky) then
                --     local ce = math.random()
                --     Lib.pv(self.UID)
                --     local fish_inform = FishMaster.List[tostring(self.UID)]
                --     Lib.pv(fish_inform)
                --     local coin   = math.ceil(fish_inform.growth.coin / 10 * (math.random() * 10))
                --     local exp    = math.ceil(fish_inform.growth.exp / 10 * (math.random() * 10))
                --     local locate = self.transform:GetPosition()
                --     if (ce > 0.5) then
                --         DropUpManager:CreateFlyItem(Enum.Aquarium.COIN_ID, nil, coin, locate)
                --     else
                --         if (ce <= 0.5 and ce >= 0.1) then
                --             DropUpManager:CreateFlyItem(Enum.Aquarium.EXP_ID, nil, exp, locate)
                --         else
                --             DropUpManager:CreateFlyItem(Enum.Aquarium.COIN_ID, nil, coin, locate)
                --             DropUpManager:CreateFlyItem(Enum.Aquarium.EXP_ID, nil, exp, locate)
                --         end
                --     end
                -- end
            end
        end)
    else
        self.executer:SetBool(Constant.StateManchine.Bool.OnFeed, false)
    end
end

function Fish:StopFeed()
    self.moveToTarget:Stop()
end

function Fish:Ate()
    if self.food then
        local foodData = self.food.foodData
        local fishModel = Me:get_fish_by_id(self.id)
        fishModel:feedFish(foodData.time)
        if not self.barHungry then
            ---@type BarHelper
            self.barHungry = self:Instantiate(self.bar)
            self.barHungry.transform:SetParent(self.transform)
            self.barHungry.transform:SetLocalPosition(Vector3.new(0, -0.8, 0))
            self.barHungry.transform:SetLocalScale(Vector3.one)
        end
        self.barHungry.gameObject:SetActive(true)
        self.timeBar = 5
        self.barHungry:SetValue(1 - fishModel:getScaleHungryTimeSlide())
        if fishModel:getScaleHungryTimeSlide() <= 0.1 then
            self.executer:SetBool(Constant.StateManchine.Bool.OnFeed, false)
            self.executer:SetTrigger(Constant.StateManchine.Trigger.OnFull)
            Event:Emit(Constant.Event.FishOnFull, self)
        else
            self.executer:SetBool(Constant.StateManchine.Bool.OnFeed, true)
        end
        AquariumManager.Instance:Feed(self.id, foodData.UID)
        if not self.timerBar then
            self.timerBar = Time:startTimer(1, function()
                if self.timeBar <= 0 then
                    self.barHungry.gameObject:SetActive(false)
                    self.timeBar = 0
                    self.timerBar = nil
                    return false
                end
                self.timeBar = self.timeBar - 1
                return true
            end)
        end
    end
end

function Fish:OnMouseDown()
    print("clicking fish")
    FishManager.Instance:ClickFish(self)
end

function Fish:ClickFeed()
end

function Fish:SellSelf()
    self:Destroy(self.gameObject)
end

_G.Fish = Fish
