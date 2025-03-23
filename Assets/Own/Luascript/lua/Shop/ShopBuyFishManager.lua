---@class ShopBuyFishManager : MonoBehaviour
---@field name TextMeshProGUI
---@field thumbnail Transform
---@field price TextMeshProGUI
---@field amount TextMeshProGUI
---@field button Button
---@field maleSelect Toggle
---@field femaleSelect Toggle
local ShopBuyFishManager = class("ShopBuyFishManager", MonoBehaviour)
ShopBuyFishManager.__path = __path

function ShopBuyFishManager:Awake()
    self.eventID = Event:Register(Constant.Event.OnBuyFish, Lib.handler(self, self.OnBuyFish))
    self.button:onClickAddListener
	(
        function ()
            AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)

            if self.femaleSelect:IsOn() then
                self.data.gender = 2
                self.femaleSelect:SetOn(false)
            end
            ShopSocket:BuyFish(self.data, function (data)
                if data.code == 3 then
                    self:IncreaseAmountBought()
                    self:ChangeGender()
                    Event:Emit(Constant.Event.UpdateFishCount)
                end
            end)
        end
	)
end

function ShopBuyFishManager:Close()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide("Popup_BuyFish")
    PopupManager:show("Popup_Shop")
end

function ShopBuyFishManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnBuyFish, self.eventID)
end

function ShopBuyFishManager:OnBuyFish(data)
    self:SetInfor(data)
end

function ShopBuyFishManager:SetInfor(data)
    local name = data.name

    ---@type GameObject
	local anim = self:Instantiate(DataManager.Instance:GetFishSprite(data.UID).gameObject)

    local price = StringFormat:Number(data.price.coin)

    local allChild = self.thumbnail:GetAllChild()
	for key, child in pairs(allChild) do
		self:Destroy(child.gameObject)
	end

    anim.transform:SetParent(self.thumbnail)

    self.name:SetText(name)
    self.price:SetText(price)
    self.sold = 0
    self.amount:SetText(self.sold)
    self.data = data
    self.data.gender = 1
end

function ShopBuyFishManager:IncreaseAmountBought()
    self.sold = self.sold + 1
    self.amount:SetText(self.sold)
end

function ShopBuyFishManager:ChangeGender()
    if self.maleSelect:IsOn() then
        self.data.gender = 2
        self.maleSelect:SetOn(false)
        self.femaleSelect:SetOn(true)
    else
        self.data.gender = 1
        self.femaleSelect:SetOn(false)
        self.maleSelect:SetOn(true)
    end
end

function ShopBuyFishManager:ToggleSex()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
end

_G.ShopBuyFishManager = ShopBuyFishManager