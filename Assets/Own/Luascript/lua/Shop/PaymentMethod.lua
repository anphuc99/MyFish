---@class PaymentMethod : MonoBehaviour
---@field goldMethod GameObject
---@field gPointMethod GameObject
---@field goldPrice TextMeshProGUI
---@field gPointPrice TextMeshProGUI
---@field goldButton Button
---@field gPointButton Button
local PaymentMethod = class("PaymentMethod", MonoBehaviour)
PaymentMethod.__path = __path
PaymentMethod.selectType = 1
PaymentMethod.TYPE = {
    DEFAULT = 1,
    STALL = 2
}

function PaymentMethod:OnDestroy()
    self.goldButton:onClickRemoveAll()
    self.gPointButton:onClickRemoveAll()
end

function PaymentMethod:SetupGoldMethod(response, func)
    local price = StringFormat:Number(response.price.coin)
    self.goldMethod:SetActive(true)
    self.goldPrice:SetText(price)
    self.goldButton:onClickRemoveAll()
    self.goldButton:onClickAddListener
	(
		function ()
            AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
            response["pay"] = "100001"
            response["finalPrice"] = price
            self:HandleType(response, func)
        end
	)
end

function PaymentMethod:SetupGPointMethod(response, func)
    local price = StringFormat:Number(response.price.point)
    self.gPointMethod:SetActive(true)
    self.gPointPrice:SetText(price)
    self.gPointButton:onClickRemoveAll()
    self.gPointButton:onClickAddListener
	(
		function ()
            AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
            response["pay"] = "100003"
            response["finalPrice"] = price
            self:HandleType(response, func)
        end
	)
end

function PaymentMethod:HandleType(response, func)
    if self.selectType == self.TYPE.DEFAULT then
        self:HandleDefaultType(response, func)
    else
        self:HandleStallType(response)
    end
end

function PaymentMethod:HandleDefaultType(response, func)
    func(response)
end

function PaymentMethod:HandleStallType(response)
    self:SetupBuyAmount(response)
end

function PaymentMethod:SetupBuyAmount(response)
    Event:Emit(Constant.Event.OnSetBuyAmount, response)
    PopupManager:show(Constant.PoppupID.Popup_BuyAmount)
end

function PaymentMethod:SetupBlockMethod()
    self.goldMethod:SetActive(true)
    self.goldPrice:SetText("???")

    self.gPointMethod:SetActive(true)
    self.gPointPrice:SetText("???")
end

function PaymentMethod:HideGoldMethod()
    self.goldMethod:SetActive(false)
end

function PaymentMethod:HideGPointMethod()
    self.gPointMethod:SetActive(false)
end

_G.PaymentMethod = PaymentMethod