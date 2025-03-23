---@class FishManager : MonoBehaviour
---@field particle GameObject
local FishManager = class("FishManager", MonoBehaviour)
FishManager.__path = __path
function FishManager:Awake()
    FishManager.Instance = self
    self.fishes = {}
    self.viewMode = false
    self.sellMode = false
    self.sellCD = 0
    self.eventID1 = Event:Register(Constant.Event.AddFish, Lib.handler(self, self.AddFish))
    self.eventID2 = Event:Register(Constant.Event.SellAdultFish, Lib.handler(self, self.SellAdultFish))
end

function FishManager:OnDestroy()
    Event:UnRegister(Constant.Event.AddFish, self.eventID1)
end

function FishManager:Update()
    if (self.sellCD > 0) then
        self.sellCD = self.sellCD - 0.1
    end
end

function FishManager:Start()
    local curAquarium = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1
    self:LoadAllFish(curAquarium)
    Event:Emit(Constant.Event.UpdateFishCount)
end

function FishManager:LoadAllFish(index)
    self:RemoveAllFish()
    self.curAquarium = index
    local data = Me:get_fish_by_index(index)

    if data == nil then
        return
    end

    for key, value in pairs(data) do
        local fishData = value:get()

        self:AddFish(fishData.UID, value)
    end
end

function FishManager:AddFish(id, classFish)
    local properties = classFish:get()
    if not classFish and properties.id then
        classFish = Me:get_fish_by_id(properties.id)
    end
    local xLeft, xRight
    Event:RequestData(Constant.Request.Pos.ZoneFishLeft, nil, function(pos)
        xLeft = pos.x
    end)
    Event:RequestData(Constant.Request.Pos.ZoneFishRight, nil, function(pos)
        xRight = pos.x
    end)
    local xPosition = math.Random(xLeft, xRight)
    local yPosition = 5 + math.random() * (2)

    ---@type GameObject
    local pref = GetFishManager.Instance:GetFishPref(id)

    ---@type GameObject
    local obj = self:Instantiate(pref)
    obj.transform:SetPosition(Vector3.new(xPosition, yPosition, 0))
    obj.transform:SetParent(AquariumManager.Instance.aquariums.aquarium1)

    ---@type Fish
    local fish = obj:GetComponent("Fish")
    local isAdult = classFish:isAdult()
    if isAdult then
        fish.gameObject.transform:SetLocalScale(fish.gameObject.transform:GetLocalScale() * 1.2)
    end
    fish:SetData(properties, classFish, isAdult)
    table.insert(self.fishes, fish)
end

function FishManager:RemoveAllFish()
    for key, fish in pairs(self.fishes) do
        self:Destroy(fish.gameObject)
    end
    self.fishes = {}
end

local function formatCurrency(amount)
    local formattedAmount = tostring(amount)
    formattedAmount = string.reverse(formattedAmount)
    formattedAmount = string.gsub(formattedAmount, "(%d%d%d)", "%1,")
    formattedAmount = string.reverse(formattedAmount)
    formattedAmount = string.gsub(formattedAmount, "^,", "")
    return tostring(formattedAmount)
end
function FishManager:SellFishProcess(fish)
    local fish_inform = FishMaster.List[tostring(fish.UID)]
    local coin, exp = 0, 0
    if fish_inform.growth then
        coin = fish_inform.growth.coin and fish_inform.growth.coin or 0
        exp = fish_inform.growth.exp and fish_inform.growth.exp or 0
        if not fish.isAdult then
            coin = math.ceil(fish_inform.price.coin / 10)
            exp = 0
        end
    end

    if (self.sellMode) then
        if (self.sellCD <= 0) then
            PopupManager:show(Constant.PoppupID.Popup_YesNoSimple_ForSellFish, {
                title = "THÔNG BÁO",
                desrciption = "Bạn có muốn bán " ..
                    fish_inform.name .. (fish.isAdult and "" or " (Chưa trưởng thành)") .. "?",
                coin = formatCurrency(coin) .. (fish.isAdult and "" or "(-90%)"),
                exp = formatCurrency(exp),
                btnYes = {
                    text = "Xác nhận",
                    onClick = function()
                        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                        PopupManager:hide(Constant.PoppupID.Popup_YesNoSimple_ForSellFish)

                        FishSocket:SellFish(fish)
                        for k, v in pairs(self.fishes) do
                            if v == fish then
                                table.remove(self.fishes, k)
                                break
                            end
                        end
                        --fish:SellSelf()
                        --FlyUpMoney
                    end
                },
                btnNo = {
                    text = "Hủy Bỏ",
                    onClick = function()
                        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                        PopupManager:hide(Constant.PoppupID.Popup_YesNoSimple_ForSellFish)
                    end
                }
            })
            self.sellCD = 1
        end
    end
end

function FishManager:ViewFishProcess(fish)
    if (self.viewMode) then
        print(self.sellCD, "cccccccccccccccccccccc")
        if (self.sellCD <= 0) then
            PopupManager:show(Constant.PoppupID.Popup_inform_normal, { id = fish.id })
            self.sellCD = 1
        end
    end
end

function FishManager:ClickFish(fish)
    print("ssssssssssssssssss")
    if (self.viewMode) then
        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
        self:ViewFishProcess(fish)
    elseif (self.sellMode) then
        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
        self:SellFishProcess(fish)
    end
end

function FishManager:toggleSellFishMode()
    self.sellMode = not self.sellMode;

    return self.sellMode
end

function FishManager:setViewMode(isOn)
    self.viewMode = isOn
    return self.viewMode
end

function FishManager:setSellMode(isOn)
    self.sellMode = isOn;
    return self.sellMode
end

function FishManager:ShowParticle(position)
    ---@type GameObject
    local particle = self:Instantiate(self.particle)
    particle.transform:SetParent(self.transform)
    particle.transform:SetPosition(position)
    return particle
end

function FishManager:RemoveParticle(obj)
    self:Destroy(obj)
end

function FishManager:SellAdultFish()
    local cnt = 0
    local AdultFish = {}
    local coin, exp = 0, 0
    local fish_inform
    for k, v in pairs(self.fishes) do
        if v.isAdult then
            fish_inform = FishMaster.List[tostring(v.UID)]
            coin = coin + fish_inform.growth.coin
            exp = exp + fish_inform.growth.exp
            table.insert(AdultFish, v)
            cnt = cnt + 1
        end
    end
    if (cnt ~= 0) then
        PopupManager:show(Constant.PoppupID.Popup_YesNoSimple_ForSellFish, {
            title = "THÔNG BÁO",
            desrciption = "Bạn có muốn bán toàn bộ " .. cnt .. " cá trưởng thành?",
            coin = formatCurrency(coin),
            exp = formatCurrency(exp),
            btnYes = {
                text = "Xác nhận",
                onClick = function()
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    PopupManager:hide(Constant.PoppupID.Popup_YesNoSimple_ForSellFish)
                    FishSocket:SellFishPacket1(AdultFish)
                    for k, v in pairs(AdultFish) do
                        for k1, v1 in pairs(self.fishes) do
                            if (v == v1) then
                                table.remove(self.fishes, k1)
                            end
                        end
                    end
                end
            },
            btnNo = {
                text = "Hủy Bỏ",
                onClick = function()
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    PopupManager:hide(Constant.PoppupID.Popup_YesNoSimple_ForSellFish)
                end
            }
        })
    end
end

_G.FishManager = FishManager
