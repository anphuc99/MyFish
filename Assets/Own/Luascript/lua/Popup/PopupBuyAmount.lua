---@class PopupBuyAmount : MonoBehaviour
---@field titleText TextMeshProGUI
---@field thumbnailImage Image
---@field amountText TextMeshProGUI
---@field priceText TextMeshProGUI
---@field buyButton Button
---@field decreaseButton Button
---@field increaseButton Button
---@field iconImage Image
---@field buttonImage Image
---@field goldSprite Sprite
---@field gPointSprite Sprite
---@field goldButtonSprite Sprite
---@field gPointButtonSprite Sprite
local PopupBuyAmount = class("PopupBuyAmount", MonoBehaviour)
PopupBuyAmount.__path = __path

function PopupBuyAmount:Awake()
    self.evOnSetBuyAmount = Event:Register(Constant.Event.OnSetBuyAmount, Lib.handler(self, self.OnSetBuyAmount))
end

function PopupBuyAmount:OnDestroy()
    Event:UnRegister(Constant.Event.OnSetBuyAmount, self.evOnSetBuyAmount)
end

function PopupBuyAmount:Close()
    PopupManager:hide(Constant.PoppupID.Popup_BuyAmount)
end

function PopupBuyAmount:OnSetBuyAmount(data)
    local title = data.name
    local sprite = DataManager.Instance:GetItemSprite(data.UID)

    self.price = data.finalPrice
    self.amount = 1

    self.titleText:SetText(title)
    self.thumbnailImage:SetSprite(sprite)
    self.buyButton:onClickRemoveAll()
    self.buyButton:onClickAddListener(function ()
        data["amount"] = self.amount
        Event:Emit(Constant.Event.OnBuyStall, data)
    end)

    self:UpdateMethodSprite(data.pay)
    self:UpdateAmountText()
    self:UpdatePriceText()
end

function PopupBuyAmount:IncreaseAmount()
    if self.decreaseButton:GetInteractable() == false then
        self.decreaseButton:SetInteractable(true)
    end

    self.amount = self.amount + 1
    self:UpdateAmountText()
    self:UpdatePriceText()

    -- Nếu vượt quá 50 thì dừng
end

function PopupBuyAmount:DecreaseAmount()
    if self.increaseButton:GetInteractable() == false then
        self.increaseButton:SetInteractable(true)
    end

    self.amount = self.amount - 1
    self:UpdateAmountText()
    self:UpdatePriceText()

    if self.amount == 1 then
        self.decreaseButton:SetInteractable(false)
    end
end

function PopupBuyAmount:UpdateMethodSprite(pay)
    if pay == "100001" then
        self.iconImage:SetSprite(self.goldSprite)
        self.buttonImage:SetSprite(self.goldButtonSprite)
    else
        self.iconImage:SetSprite(self.gPointSprite)
        self.buttonImage:SetSprite(self.gPointButtonSprite)
    end
end

function PopupBuyAmount:UpdateAmountText()
    self.amountText:SetText(self.amount)
end

function PopupBuyAmount:UpdatePriceText()
    local price = StringFormat:Number(self.price * self.amount)
    self.priceText:SetText(price)
end

_G.PopupBuyAmount = PopupBuyAmount