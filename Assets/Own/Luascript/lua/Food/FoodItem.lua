---@class FoodItem : MonoBehaviour
---@field sprFood SpriteRenderer
local FoodItem = class("FoodItem", MonoBehaviour)
FoodItem.__path = __path

function FoodItem:SetFood(foodData)
    self.foodData = foodData
    self.sprFood:SetSprite(foodData.sprite)
end

function FoodItem:move()
    LeanTween:moveY(self.gameObject, -10, 20):setOnComplete(function ()
        self:Destroy(self.gameObject)
    end)
end

_G.FoodItem = FoodItem
