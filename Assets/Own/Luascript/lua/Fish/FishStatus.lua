---@class FishStatus : MonoBehaviour
---@field executer FSMC_Executer
---@field thinking FishThinking
---@field fish Fish
local FishStatus = class("FishStatus", MonoBehaviour)
FishStatus.__path = __path


local overThinking = {
    "Mỗi ngày, tôi ngước nhìn ánh sáng chói lọi.",
    "Trái tim tôi đập nhanh khi thấy sự phong phú.",
    "Cảm giác êm đềm khi lướt qua góc của bể nước.",
    "Tôi ngẫm nghĩ về thách thức và niềm vui.",
    "Bạn cảm thấy thế nào hôm nay, chủ nhân?",
    "Chủ nhân đã bơi lội với tôi hôm nay chưa?",
    "Khoảnh khắc bình yên giữa tảng đá, rễ cây.",
    "Tôi tự hào vì có một chủ nhân như vậy, luôn luôn đồng hành cùng tôi.",
    "Tôi tự hào vì có một chủ nhân như vậy, luôn luôn đồng hành cùng tôi.",
    "Tôi hy vọng bạn luôn khỏe mạnh và hạnh phúc, chủ nhân.",
}

local HungryThinking = {
    "Đói quá, mong chủ nhân sớm đến với thức ăn.",
    "Thức ăn ơi, tôi đang chờ đợi bạn đấy.",
    "Chủ nhân ơi, tôi đang rất cần thức ăn.",
    "Xin hãy đến với tôi, tôi đang đói lắm.",
    "Tôi hy vọng chủ nhân không quên cái đói của tôi.",    
}

function FishStatus:Awake()
    self.evFishOnFull = Event:Register(Constant.Event.FishOnFull, Lib.handler(self, self.FishOnFull))
end

function FishStatus:Start()
    self:CheckHungry()
end

function FishStatus:OnDestroy()
    Event:UnRegister(Constant.Event.FishOnFull, self.evFishOnFull)
    Time:stopTimer(self.time)
    Time:stopTimer(self.timeAdult)
end

---@return Fish1
function FishStatus:GetFishModel()
    return Me:get_fish_by_id(self.fish.id)
end

function FishStatus:FishOnFull(fish)
    if fish == self.fish then
        self.executer:SetBool(Constant.StateManchine.Bool.OnHungry, false)        
    end
end

function FishStatus:CheckHungry()
    if not self.time then
        self.time = Time:startTimer(1, function ()
            local rs, msg = pcall(function ()
                if self:GetFishModel():IsHungry() then
                    self.executer:SetBool(Constant.StateManchine.Bool.OnHungry, true)
                    return false
                end
                return true                
            end)
            if not rs then
                return false
            else
                return msg
            end
        end)        
    end
end

function FishStatus:CheckAdult()
    self.timeAdult =  Time:startFramer(1, function ()
        local rs, msg = pcall(function ()
            if self:GetFishModel():isAdult() then            
                self.executer:SetTrigger(Constant.StateManchine.Trigger.OnAdult)
                return false
            end
            return true            
        end)
        if not rs then
            return false
        else
            return msg
        end
    end)
end

function FishStatus:RandomThinking()
    local think
    if self:GetFishModel():getScaleHungryTimeSlide() >= 0.5 then
        think = HungryThinking[math.random(#HungryThinking)]
    else
        think = overThinking[math.random(#overThinking)]
    end
    self:Thinking(think)
end

function FishStatus:Normal()    
    LeanTween:delayCall(self.gameObject,math.random(20, 40), function ()
        self.executer:SetTrigger(Constant.StateManchine.Trigger.OnThinking)
    end)
end

function FishStatus:Thinking(think)    
    self.thinking:Thinking(think)
end

function FishStatus:Hungry()
    self.thinking:Hungry()
end

function FishStatus:Full()
    self:CheckHungry()
    self.thinking:Full()
end

function FishStatus:Adult()
    self.fish.gameObject.transform:SetLocalScale(self.gameObject.transform:GetLocalScale() * 1.2)
end


_G.FishStatus = FishStatus