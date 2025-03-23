---@class ShopDecorationManager : MonoBehaviour
local ShopDecorationManager = class("ShopDecorationManager", MonoBehaviour)
ShopDecorationManager.__path = __path

function ShopDecorationManager:Awake()
    self.eventID = Event:Register(Constant.Event.OnBuyDecoration, Lib.handler(self, self.OnBuyDecoration))
end

function ShopDecorationManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnBuyDecoration, self.eventID)
end

function ShopDecorationManager:OnBuyDecoration(data)
    ShopSocket:BuyDecoration(data)
end

_G.ShopDecorationManager = ShopDecorationManager