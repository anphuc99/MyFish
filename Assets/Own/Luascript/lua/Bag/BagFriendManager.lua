---@class BagFriendManager : BagManager
local BagFriendManager = class("BagFriendManager", BagManager)
BagFriendManager.__path = __path
BagFriendManager.isFirstLoaded = false

function BagFriendManager:AddBagItem(UID)	
	Me.other:AddBagItem(UID)	
	Event:Emit(Constant.Event.DataOnChangeBagItem)
end

function BagFriendManager:SubtractBagItem(UID)
	Me.other:SubtractBagItem(UID)
	Event:Emit(Constant.Event.DataOnChangeBagItem)
end

_G.BagFriendManager = BagFriendManager