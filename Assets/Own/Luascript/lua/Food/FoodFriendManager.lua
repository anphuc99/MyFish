---@class FoodFriendManager : FoodManager
local FoodFriendManager = class("FoodFriendManager", FoodManager)
FoodFriendManager.__path = __path

function FoodFriendManager:ConsumeFood()
    local bagItem = Me.other:GetBagItemByUID(self.currentFoodUID)

    if bagItem == nil then
        self.foodImage:SetSprite(self.outOfFoodSprite)
        self.amountText.gameObject:SetActive(false)
        self.currentFoodUID = nil
    else
        self.amountText:SetText(bagItem.amount)
        self.amountText.gameObject:SetActive(true)
    end
end

_G.FoodFriendManager = FoodFriendManager
