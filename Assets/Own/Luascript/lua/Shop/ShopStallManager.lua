---@class ShopStallManager : MonoBehaviour
local ShopStallManager = class("ShopStallManager", MonoBehaviour)
ShopStallManager.__path = __path

function ShopStallManager:Awake()
    self.eventID = Event:Register(Constant.Event.OnBuyStall, Lib.handler(self, self.OnBuyStall))
end

function ShopStallManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnBuyStall, self.eventID)
end

function ShopStallManager:OnBuyStall(data)
	local maxStorage = BagManager.Instance.maxStorage
	local used = 0
	local dataBag = Me:GetBagItem()
	for key, value in pairs(dataBag) do
		used = used + 1
	end
    if used == maxStorage and Me:CheckBagExistItemByUID(data.UID) == false then
		PopupManager:show(Constant.PoppupID.Popup_Notification, {
			title = "THÔNG BÁO",
			desrciption = "Túi đã đầy!\nHãy làm trống túi trước tiên nhé!",
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
		return
	end
    ShopSocket:BuyStall(data)
end

_G.ShopStallManager = ShopStallManager