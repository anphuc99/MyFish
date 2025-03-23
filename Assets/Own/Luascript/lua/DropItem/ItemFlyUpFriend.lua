---@class ItemFlyUpFriend : ItemFlyUp
local ItemFlyUpFriend = class("ItemFlyUpFriend", ItemFlyUp)
ItemFlyUpFriend.__path = __path

function ItemFlyUpFriend:Fly()
        ---@type Vector3
        local targetPos = Vector3.up * 10
        if(self.isCollect==0) then
            self.isCollect = 1
            if self.itemId== Constant.Currency.Gold then
                LeanTween:scale(self.gameObject, Vector3.new(0.7,0.7,0.7), 2);
            else
                LeanTween:scale(self.gameObject, Vector3.new(0.3,0.3,0.3), 2);
            end
            
            LeanTween:move(self.gameObject, targetPos, 2)
                :setOnComplete(function ()
                    self.parent:FlyComplete(self)
                    self:Destroy(self.gameObject)
                end)
                :setEase(LeanTweenType.easeInBack)
            
        end
end




_G.ItemFlyUpFriend = ItemFlyUpFriend
