---@class FoodManager : MonoBehaviour
---@field foodImage Image 
---@field amountText TextMeshProGUI
---@field outOfFoodSprite Sprite
---@field foodItem FoodItem
local FoodManager = class("FoodManager", MonoBehaviour)
FoodManager.__path = __path

function FoodManager:Awake()
    FoodManager.Instance = self
    self.currentFoodUID = nil
    self.evOnSubtractBagItem = Event:Register(Constant.Event.OnSubtractBagItem, Lib.handler(self, self.UseFoodItem))
    self.evDataOnSubtractBagItem = Event:Register(Constant.Event.DataOnChangeBagItem, Lib.handler(self, self.ConsumeFood))
end

function FoodManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnSubtractBagItem, self.evOnSubtractBagItem)
    Event:UnRegister(Constant.Event.DataOnChangeBagItem, self.evDataOnSubtractBagItem)
end

function FoodManager:Start()
    self:SetFoodFirstTime()
end

function FoodManager:SetFoodFirstTime()
    local item = Me:FirstOrDefaultFoodInBag()
    
    if item ~= nil then
        self:SetFood(item)
    else
        self:ConsumeFood()
    end
end

function FoodManager:SetFood(data)
    self.currentFoodUID = data.UID
    local sprite = DataManager.Instance:GetItemSprite(data.UID)
       
    self.foodImage:SetSprite(sprite)
    self.amountText:SetText(data.amount)
    self.amountText.gameObject:SetActive(true)
end

function FoodManager:AddFood(data)
    if self.currentFoodUID == data.UID then
        self.amountText:SetText(data.amount)
        self.amountText.gameObject:SetActive(true)
    end
end

function FoodManager:ConsumeFood()
    local bagItem = Me:GetBagItemByUID(self.currentFoodUID)

    if bagItem == nil then
        self.foodImage:SetSprite(self.outOfFoodSprite)
        self.amountText.gameObject:SetActive(false)
        self.currentFoodUID = nil
    else
        self.amountText:SetText(bagItem.amount)
        self.amountText.gameObject:SetActive(true)
    end
end

function FoodManager:HandleFood()
    -- Check exist food
    if self.currentFoodUID == nil then
        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = "Thức ăn đã hết!",
            btnYes = {
                text = "Đồng Ý",
                onClick = function()
                        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                        PopupManager:hide(Constant.PoppupID.Popup_Notification)
                    end
            },
            btnNo = {
                disable = true
            }
        })
    else
        BagSocket:UseItem(self.currentFoodUID)
    end
end

function FoodManager:UseFoodItem(UID, resp)
    local type = DataManager.Instance:GetStallByUID(UID).type
    local data = Me:GetShopStallByID(UID)
    if type == Constant.StallType.Food then         
        for i = 1, 5, 1 do
            ---@type FoodItem
            local foodItem = self:Instantiate(self.foodItem)
           local  foodData = {
                UID = UID,
                time = data.data.time,
                type = data.type,
                sprite = DataManager.Instance:GetFoodSprite(data.type)
           }
           local x = math.Random(-2.5, 3.5)
           local y = math.Random(2.5, 3)
           foodItem.transform:SetPosition(Vector3.new(x,y,0))
           foodItem:SetFood(foodData)           
           foodItem:move()
           Event:Emit(Constant.Event.FeedFish, foodItem)
        end
    end
    
end



_G.FoodManager = FoodManager