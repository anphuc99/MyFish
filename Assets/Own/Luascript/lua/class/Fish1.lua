---@class Fish1
local Fish1 = class("Fish1")


function Fish1:ctor(properties)
    self.id = properties.id
    self.UID= properties.UID
    self.properties=properties
    self.attributes={}
end


function Fish1:update(any)
    for k, v in pairs(any) do
        self.properties[k] = v
    end
end
---@return {id:string,UID:string,gender:number,level:number,coin_bonus:number,exp_bonus:number,hungry_full:number,max_hungry:number,grow_up_empty:number,grow_up_full:number,drop_item_at:number}
function Fish1:get()
    return self.properties
end

---@return ShopFish
function Fish1:GetInfo()
    local shopFish = Me:GetShopFishByID(self.UID)
    return shopFish
end

function Fish1:setData(key,value)
    self.attributes[tostring(key)]=value
end
---@return any
function Fish1:getData(key)
    return self.attributes[tostring(key)]
end
function Fish1:getHungryTime()
    local now=os.time()
    local properties=self.properties
    if math.ceil(properties.hungry.hungry_full / 1000)<now then
        return 0
    else
        return math.ceil(properties.hungry.hungry_full / 1000)-now
    end
end
function Fish1:getScaleHungryTimeSlide()
    local hungry=self.properties.hungry
    local max=math.ceil(hungry.max/1000)
    return (max-self:getHungryTime())/max
end
function Fish1:IsHungry()
    return self:getScaleHungryTimeSlide() >= 0.9
end

function Fish1:isAdult()
    local properties=self.properties
   
    local now=os.time()
    local grow_up_full=math.ceil(properties.grow_up.grow_up_full / 1000)
    if now>=grow_up_full then
        return true
    end
    return false
end
function Fish1:timeAdultRemaining()
    local properties=self.properties
    local now=os.time()
    local grow_up_full=math.ceil(properties.grow_up.grow_up_full / 1000)
    local rs=grow_up_full-now
    return rs>=0 and rs or 0
end
function Fish1:timeAdultMax()
    local properties=self.properties
    local grow_up_full=math.ceil(properties.grow_up.grow_up_full / 1000)
    local grow_up_empty=math.ceil(properties.grow_up.grow_up_empty / 1000)
    return grow_up_full-grow_up_empty
end
function Fish1:getScaleAdultTimeSlide()
    local max=self:timeAdultMax()
    local current=self:timeAdultRemaining()
    return (max-current)/max
end

function Fish1:feedFish(milisecond)
    local now = os.time() * 1000
    local time_remaing = self:getHungryTime() * 1000
    local properties=self.properties
    if time_remaing == 0 then
        properties.hungry.hungry_full = now + milisecond
    else        
        properties.hungry.hungry_full = properties.hungry.hungry_full + milisecond
    end

    if self:getHungryTime() * 1000 > properties.hungry.max then
        properties.hungry.hungry_full = now + properties.hungry.max
    end    
end
_G.Fish1=Fish1