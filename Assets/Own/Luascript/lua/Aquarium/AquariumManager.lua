---@class AquariumManager : MonoBehaviour
---@field pos table
---@field icon GameObject
---@field aquariums table
local AquariumManager = class("AquariumManager", MonoBehaviour)
AquariumManager.__path = __path

function AquariumManager:Awake()
    AquariumManager.Instance = self
    self.listFishFeed = {}
    self.evOnChangAquarium = Event:Register(Constant.Event.OnChangeAquarium, Lib.handler(self, self.OnChangeAquarium))
end

function AquariumManager:Start()
    --self.dropItem = {}
    self:ShowDropItem()
end

function AquariumManager:OnDestroy()
    Time:stopTimer(self.timerID)
    self:SendFood()
    Event:UnRegister(Constant.Event.OnChangeAquarium, self.evOnChangAquarium)
end

function AquariumManager:ShowDropItem()
    local currentAquarium = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1
    math.randomseed(os.time())
    print("Calling aquarium")
    local data = Me:get_aquarium()[currentAquarium].inform:get()
    local dropItem = data[Enum.Aquarium.DROP_ITEM]
    local player = Me:get_player("ShowDropItem"):get()
    local player_lv = player.lv_level and player.lv_level or 1
    player_lv = player_lv ~= 0 and player_lv or 1
    for k, v in pairs(dropItem) do
        local id = tostring(k)
        local value = dropItem[id] and dropItem[id] or 0
        local dropratio = math.ceil((value / (10 * player_lv))) / 10
        dropratio = dropratio < 1 and 1 or dropratio
        while value > 0 do
            local dropValue = (10 * player_lv) * dropratio
            if (dropValue > value) then
                dropValue = value
            end
            local pos = Vector3.new(self.pos.left + math.random() * (self.pos.right - self.pos.left), self.pos.y, 0)
            DropUpManager.Instance:CreateDropItem(id, nil, dropValue, currentAquarium, pos)
            value = value - dropValue
        end
    end
end

function AquariumManager:Feed(fishID, footID)
    if not self.listFishFeed[footID] then
        self.listFishFeed[footID] = {}
    end
    table.insert(self.listFishFeed[footID], fishID)

    if not self.timerID then
        self.timerID = Time:startTimer(2, Lib.handler(self, self.SendFood))
    end
end

function AquariumManager:SendFood()
    for key, value in pairs(self.listFishFeed) do
        local foodID = key
        AquariumSocket:feedFish(foodID, value)
    end
    self.timerID = nil
    self.listFishFeed = {}
end

function AquariumManager:OnChangeAquarium(index)
    if DataLocalManager:GetValue(Constant.Data.curAquarium) or 1 ~= index then
        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = "Bạn có muốn đổi hồ cá không?",
            btnYes = {
                text = "Đồng Ý",
                onClick = function()
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    DataLocalManager:SetValue(Constant.Data.curAquarium, index)
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                    SceneLoader:LoadData()
                    Time:startTimer(0.5, function()
                        SceneLoader:LoadCurScene()
                    end)
                end
            },
            btnNo = {
                text = "Hủy",
                onClick = function()
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                end
            }
        })
    end
end

_G.AquariumManager = AquariumManager
