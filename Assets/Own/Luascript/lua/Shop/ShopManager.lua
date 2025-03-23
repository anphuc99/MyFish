---@class ShopManager : MonoBehaviour
---@field prefabs table
---@field contents table
local ShopManager = class("ShopManager", MonoBehaviour)
ShopManager.__path = __path
ShopManager.isLoaded = false

function ShopManager:Awake()
	ShopManager.Instance = self
end

function ShopManager:Close()
	AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
	PopupManager:hide("Popup_Shop")
end

function ShopManager:AddItem(prefab, content)
	local item = self:Instantiate(prefab)
	item.transform:SetParent(content)
	return item
end

function ShopManager:AddFishItem(data)
	---@type FishItem
	local fishItem = self:AddItem(self.prefabs.fish, self.contents.fish)
	
	---@type GameObject
	local anim = self:Instantiate(DataManager.Instance:GetFishSprite(data.UID).gameObject)

	---@type FishAnim
	local fishAnim = anim:GetComponent("FishAnim")
	fishAnim.skeletonGraphic:SetColor(Color.white)

	-- Lưu dữ liệu
	data.anim = fishAnim
	data.coin = data.price.coin
	data.point = data.price.point
	fishItem:SetData(data)
	
	local name = data.name
	local level = data.lv_required
	local growth = StringFormat:Time(data.growth_time)
	local income = StringFormat:Number(data.growth.coin)
	local exp = StringFormat:Number(data.growth.exp)

	-- Check xem có cá có trong fish_open không
	local fishOpen = Me:get_player():get().fish_open
	fishOpen = Lib.splitString(fishOpen, ',', true)
	local isBlocked = true
	for key, value in pairs(fishOpen) do
		if value == data.UID then
			isBlocked = false
			break
		end
	end

	if isBlocked then
		fishItem.blockItem.block:SetActive(true)
		fishAnim.skeletonGraphic:SetColor(Color.black)
		fishItem.blockItem.text:SetText("Lai cá để mở")

		name = "???"
		level = "???"
		growth = "???"
		income = "???"
		exp = "???"
		data.price.coin = nil
		data.price.point = nil
	end

	anim.transform:SetParent(fishItem.thumbnail)

	fishItem.name:SetText(name)
	fishItem.level:SetText(level)
	fishItem.growth:SetText(growth)
	fishItem.income:SetText(income)
	fishItem.experience:SetText(exp)

	self:HandlePaymentMethod(data, fishItem, Lib.handler(self, self.SetupBuyFish))
end

function ShopManager:AddDecorationItem(data)
	---@type DecorationItem
	local decorationItem = self:AddItem(self.prefabs.decoration, self.contents.decoration)
	
	-- Lưu dữ liệu
	data.coin = data.price.coin
	data.point = data.price.point
	data.coin = data.bonus.coin
	data.exp = data.bonus.exp
	decorationItem:SetData(data)

	local name = data.name
	local level = data.lv_required
	local gold = StringFormat:Number(data.bonus.coin)
	local exp = StringFormat:Number(data.bonus.exp)
	local sprite = DataManager.Instance:GetDecorationSprite(data.UID)

	-- Check xem có đủ level để mở khóa đồ trang trí hay không
	local playerLevel = Me:get_player():get().lv_level
	if playerLevel < level then
		decorationItem.thumbnail:SetColor(Color.black)
		decorationItem.blockItem.block:SetActive(true)
		decorationItem.blockItem.text:SetText("Yêu cầu lv: " .. level)

		name = "???"
		level = "???"
		gold = "???"
		exp = "???"
		data.price.coin = nil
		data.price.point = nil
	end

	decorationItem.name:SetText(name)
	decorationItem.level:SetText(level)
	decorationItem.gold:SetText(gold)
	decorationItem.experience:SetText(exp)
	decorationItem.thumbnail:SetSprite(sprite)

	decorationItem.pay.selectType = PaymentMethod.TYPE.DEFAULT
	self:HandlePaymentMethod(data, decorationItem, Lib.handler(self, self.SetupBuyDecoration))
end

---@param data ShopStall
function ShopManager:AddStallItem(data)
	local name = data.name
	local sprite = data:GetSprite()

	---@type StallItem
	local stallItem = self:AddItem(self.prefabs.stall, self.contents.stall)

	stallItem.name:SetText(name)
	stallItem.thumbnail:SetSprite(sprite)

	stallItem.pay.selectType = PaymentMethod.TYPE.STALL
	self:HandlePaymentMethod(data, stallItem)
end

function ShopManager:GetFishShop()
	local data = Me:GetShopFish()
	for index, value in pairs(data) do
		self:AddFishItem(value)
	end
end

function ShopManager:GetDecorationShop()
	local data = Me:GetShopDecoration()
	for index, value in pairs(data) do
		self:AddDecorationItem(value)
	end
end

function ShopManager:GetStallShop()
	local data = Me:GetShopStall()
	for index, value in pairs(data) do
		self:AddStallItem(value)
	end
end

function ShopManager:SetupBuyFish(data)
	PopupManager:hide("Popup_Shop")
	PopupManager:show("Popup_BuyFish")
	Event:Emit(Constant.Event.OnBuyFish, data)
end

function ShopManager:SetupBuyDecoration(data)
	Event:Emit(Constant.Event.OnBuyDecoration, data)
end

function ShopManager:HandlePaymentMethod(response, item, func)
	local coin = response.price.coin
	local point = response.price.point
	if coin ~= nil and point ~= nil then
		item.pay:SetupGoldMethod(response, func)
		item.pay:SetupGPointMethod(response, func)
	elseif coin ~= nil and point == nil then
		item.pay:SetupGoldMethod(response, func)
		item.pay:HideGPointMethod()
	elseif coin == nil and point ~= nil then
		item.pay:SetupGPointMethod(response, func)
		item.pay:HideGoldMethod()
	else
		item.pay:SetupBlockMethod()
	end
end

function ShopManager:HandleBlockFishAfterLevelUp(fishOpen)
	local fishItems = self.contents.fish:GetAllChild()
	for index, value in pairs(fishItems) do
		---@type FishItem
		local fishItem = value:GetComponent("FishItem")
		local data = fishItem:GetData()

		if fishItem.blockItem.block:GetActive() ~= false then
			fishOpen = Lib.splitString(fishOpen, ',', true)
			for k, v in pairs(fishOpen) do
				if v == data.UID then
					self:SetDataForFish(fishItem)
					fishItem.blockItem.block:SetActive(false)
					break
				end
			end
		end
	end
end

function ShopManager:HandleBlockDecorationAfterLevelUp(level, lastLevel)
	local decorationItems = self.contents.decoration:GetAllChild()
	for index, value in pairs(decorationItems) do
		---@type DecorationItem
		local decorationItem = value:GetComponent("DecorationItem")
		local data = decorationItem:GetData()
		if (level >= data.lv_required and lastLevel < data.lv_required) then
			self:SetDataForDecoration(decorationItem)
			decorationItem.blockItem.block:SetActive(false)
		end
	end
end

function ShopManager:SetDataForFish(fishItem)
	local data = fishItem:GetData()
	local name = data.name
	local level = data.lv_required
	local growth = StringFormat:Time(data.growth_time)
	local income = StringFormat:Number(data.growth.coin)
	local exp = StringFormat:Number(data.growth.exp)

	data.price.coin = data.coin
	data.price.point = data.point

	data.anim.skeletonGraphic:SetColor(Color.white)
	fishItem.name:SetText(name)
	fishItem.level:SetText(level)
	fishItem.growth:SetText(growth)
	fishItem.income:SetText(income)
	fishItem.experience:SetText(exp)
	
	self:HandlePaymentMethod(data, fishItem, Lib.handler(self, self.SetupBuyFish))
end

function ShopManager:SetDataForDecoration(decorationItem)
	local data = decorationItem:GetData()
	local name = data.name
	local level = data.lv_required
	local gold = StringFormat:Number(data.coin)
	local exp = StringFormat:Number(data.exp)

	data.price.coin = data.coin
	data.price.point = data.point

	decorationItem.name:SetText(name)
	decorationItem.level:SetText(level)
	decorationItem.gold:SetText(gold)
	decorationItem.experience:SetText(exp)
	decorationItem.thumbnail:SetColor(Color.white)
	
	self:HandlePaymentMethod(data, decorationItem, Lib.handler(self, self.SetupBuyFish))
end

_G.ShopManager = ShopManager