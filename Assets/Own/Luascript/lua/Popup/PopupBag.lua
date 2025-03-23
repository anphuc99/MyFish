---@class PopupBag : MonoBehaviour
---@field prefab GameObject
---@field content Transform
---@field detail DetailItem
---@field usedText TextMeshProGUI
---@field currentSelect BagItem
local PopupBag = class("PopupBag", MonoBehaviour)
PopupBag.__path = __path
PopupBag.isFirstLoaded = false

function PopupBag:Awake()
	-- Singleton
    PopupBag.Instance = self

    self.selectSize = Vector3.new(1, 1, 1)
    self.deselectSize = Vector3.new(1, 1, 1)

	-- Lưu trữ các container
	self.containers = {}
	-- Lưu trữ số ô đã sử dụng
	self.used = 0
	-- Thêm container vào containers
	for i = 1, self.content:GetChildCount(), 1 do
		self.containers[i] =
		{
			UID = 0,
			item = self.content:GetChild(i)
		}
	end
end

function PopupBag:OnBeginShow()
    self.evDataOnChangeBagItem = Event:Register(Constant.Event.DataOnChangeBagItem, Lib.handler(self, self.SortItem))
	self:SortItem()
end

function PopupBag:OnEndHide()
    Event:UnRegister(Constant.Event.DataOnChangeBagItem, self)
end

function PopupBag:Close()
	AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
	PopupManager:hide(self.PopupID)
end

function PopupBag:LoadItem()
    local data = Me:GetBagItem()
	for index, value in pairs(data) do
		self:AddItem(value, index)

		-- Setup self.used
		self.used = self.used + 1
	end

	self:SetUsedText()
end


---@param data _BagItem
---@param number number
function PopupBag:AddItem(data, number)
	local name = data:GetInfo().name
	local amount = data.amount
	local sprite = data:GetSprite()
	local description = data:GetInfo().description

	local container = self.containers[number]
	local itemInContainer = self:GetItem(container)
	self:SetContainerToUID(container, data.UID)

	itemInContainer.amount:SetText(amount)
	itemInContainer.thumbnail:SetSprite(sprite)
	itemInContainer.button:onClickAddListener(
		function()
			AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
			self.detail:SetValue(name, sprite, data.UID, description)

			-- Trường hợp item là food
			local type = DataManager.Instance:GetBagItemTypeByUID(data.UID)
			if type == Constant.StallType.Food then
				self.detail.button:onClickRemoveAll()
				self.detail.button:onClickAddListener(
					function ()
						AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
						FoodManager.Instance:SetFood(data)
						PopupManager:hide(self.PopupID)
					end
				)
			end

			-- Trường hợp không cho sử dụng item
			for index, value in pairs(DetailItem.prohibitUID) do
				if tonumber(data.UID) == value then
					self.detail:BlockUse()
					break
				end
			end

			self:SelectItem(itemInContainer)            
		end
	)

	self:SetActiveItem(itemInContainer, true)
end

function PopupBag:SortClick()
	AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
	self:SortItem()
end

function PopupBag:SortItem()
	Me:SortBagItem()
	
	-- Xóa các item đang ở trong túi
	for key, value in pairs(self.containers) do
		if value.UID ~= 0 then
			local container = self:GetContainerByUID(value.UID)
			local itemInContainer = self:GetItem(container)

			self:SetContainerToUID(container, 0)
			itemInContainer.button:onClickRemoveAll()
			
			self:DeSelectItem()
			self.detail:ShowDetail(false)
			self:SetActiveItem(itemInContainer, false)
		end
	end
	self.used = 0

	self:LoadItem()
end

function PopupBag:GetContainerByUID(UID)
	for i = 1, #self.containers, 1 do
		if self.containers[i].UID == UID then
			return self.containers[i]
		end
	end
end

function PopupBag:SetContainerToUID(container, UID)
	container.UID = UID
end

function PopupBag:CheckExistItemByUID(UID)
	for i = 1, #self.containers, 1 do
		if self.containers[i].UID == UID then
			return true
		end
	end
	return false
end

---@return BagItem
function PopupBag:GetItem(container)
	return container.item:GetComponent("BagItem")
end

function PopupBag:SetUsedText()
	self.usedText:SetText(self.used .. "/" .. #self.containers)
end

function PopupBag:SetActiveItem(item, bool)
	item.amount.gameObject:SetActive(bool)
	item.thumbnail.gameObject:SetActive(bool)
end

function PopupBag:SelectItem(item)
	self:DeSelectItem()

	item.transform:SetLocalScale(self.selectSize)
	self.currentSelect = item
end

function PopupBag:DeSelectItem()
	if self.currentSelect ~= nil then
		self.currentSelect.transform:SetLocalScale(self.deselectSize)
	end
end

-- Trả về số thứ tự của container
function PopupBag:GetEmptyContainerIndex()
	for i = 1, #self.containers, 1 do
		if self.containers[i].UID == 0 then
			return i
		end
	end
end

_G.PopupBag = PopupBag