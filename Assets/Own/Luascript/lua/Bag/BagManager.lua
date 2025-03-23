---@class BagManager : MonoBehaviour
---@field maxStorage number
local BagManager = class("BagManager", MonoBehaviour)
BagManager.__path = __path
BagManager.isFirstLoaded = false

function BagManager:Awake()
    BagManager.Instance = self

	self.eventID1 = Event:Register(Constant.Event.OnAddBagItem, Lib.handler(self, self.AddBagItem))
	self.eventID2 = Event:Register(Constant.Event.OnSubtractBagItem, Lib.handler(self, self.SubtractBagItem))
end

function BagManager:OnDestroy()
	Event:UnRegister(Constant.Event.OnAddBagItem, self.eventID1)
	Event:UnRegister(Constant.Event.OnSubtractBagItem, self.eventID2)
end

function BagManager:AddBagItem(UID)	
	Me:AddBagItem(UID)	
	Event:Emit(Constant.Event.DataOnChangeBagItem)
end

function BagManager:SubtractBagItem(UID)
	Me:SubtractBagItem(UID)
	Event:Emit(Constant.Event.DataOnChangeBagItem)
end

_G.BagManager = BagManager