---@class PopupBagFriend : PopupBag
local PopupBagFriend = class("PopupBagFriend", PopupBag)
PopupBagFriend.__path = __path

function PopupBagFriend:LoadItem()
    local data = Me.other:GetBagItem()
	for index, value in pairs(data) do
        local type = DataManager.Instance:GetBagItemTypeByUID(value.UID)
        if type == Constant.StallType.Food then            
            self:AddItem(value, index)
            self.used = self.used + 1
        end
		-- Setup self.used
	end

	self:SetUsedText()
end

_G.PopupBagFriend = PopupBagFriend