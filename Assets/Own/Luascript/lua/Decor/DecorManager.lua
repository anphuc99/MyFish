---@class DecorManager : MonoBehaviour
---@field prefab GameObject
---@field content Transform
---@field view GameObject
---@field currentSelect DecorItem
---@field actionButton Button
---@field placeManager PlaceManager
local DecorManager = class("DecorManager", MonoBehaviour)
DecorManager.__path = __path
DecorManager.isFirstLoaded = false

local deselectSize = Vector3.new(1, 1, 1)
local selectSize = Vector3.new(1.1, 1.1, 1.1)

function DecorManager:Awake()
	-- Singleton
    DecorManager.Instance = self

	-- Lưu trữ các container
	self.container = {}

	self.eventID1 = Event:Register(Constant.Event.OnAddDecorItem, Lib.handler(self, self.AddDecorItem))
	self.eventID2 = Event:Register(Constant.Event.OnSubtractDecorItem, Lib.handler(self, self.SubtractDecorItem))
end

function DecorManager:OnDestroy()
	Event:UnRegister(Constant.Event.OnAddDecorItem, self.eventID1)
	Event:UnRegister(Constant.Event.OnSubtractDecorItem, self.eventID2)
end

function DecorManager:Start()
	self:LoadItem()
	self.placeManager:LoadDecor()
end

function DecorManager:AddDecorItem(UID)
	local isFirstInit = Me:IsFirstInitDecorItem(UID)
    local selectItem = Me:GetDecorItemByUID(UID)
	
	if isFirstInit then
		self:AddItem(selectItem)
	else
        local decorItem = self:GetDecorItemByUID(UID)
		decorItem.amount:SetText(selectItem.amount)
	end
	--Event:Emit(Constant.Event.OnAddOrSubstractDecoItem, UID, Enum.BONUS.DELETE)
end

function DecorManager:SubtractDecorItem(UID)
	local isDeleted = Me:IsDeletedDecorItem(UID)
	local selectItem = Me:GetDecorItemByUID(UID)
    local decorItem = self:GetDecorItemByUID(UID)
    local originItem = self:GetDecorOriginByUID(UID)
	
	if isDeleted then
		self:Destroy(originItem)
		
		for index, value in pairs(self.container) do
			if value.UID == UID then
				table.remove(self.container, index)
				break
			end
		end

		self.currentSelect = nil
		self:HandleActionButton()
	else
		decorItem.amount:SetText(selectItem.amount)
	end
	--Event:Emit(Constant.Event.OnAddDecorItem, UID, Enum.BONUS.ADD)
end

function DecorManager:LoadItem()
	Me:InitDecorItem()
    local data = Me:GetDecorItem()
	for index, value in pairs(data) do
		self:AddItem(value)
	end
end

function DecorManager:AddItem(data)
	local amount = data.amount
	local sprite = DataManager.Instance:GetDecorationSprite(data.UID)

    local item = self:Instantiate(self.prefab)
    item.transform:SetParent(self.content)

    local decorItem = item:GetComponent("DecorItem")
	decorItem.amount:SetText(amount)
	decorItem.thumbnail:SetSprite(sprite)
	decorItem.button:onClickAddListener(
		function()
			self:SelectItem(decorItem)
			self:SetFunctionActionButton(data)
			self:HandleActionButton()
		end
	)

    table.insert(self.container, {
        UID = tonumber(data.UID),
        item = decorItem,
		origin = item
    })
end

function DecorManager:OnDecorMode()
	self:DeSelectItem()
	self:HandleActionButton()
	self.placeManager:EditDecor()
	self.placeManager:UpdateCurrentAmountText()
	self.placeManager:SetUpBoundBar()
	
	self.view:SetActive(true)
	PhotoManager.Instance:OnDecorMode()
end

function DecorManager:OffDecorModeNoSave()
	self.placeManager:DestroyAllDecors()
	self.placeManager:LoadDecor()

	self.view:SetActive(false)
	PhotoManager.Instance:OffDecorMode()
end

function DecorManager:OffDecorModeSave()
	self.placeManager:HandleSave()
	self.placeManager:CancelDecor()

	self.view:SetActive(false)
	PhotoManager.Instance:OffDecorMode()
end

function DecorManager:GetDecorItemByUID(UID)
	for index, value in pairs(self.container) do
        if value.UID == UID then
            return value.item
        end
    end
end

function DecorManager:GetDecorOriginByUID(UID)
	for index, value in pairs(self.container) do
        if value.UID == UID then
            return value.origin
        end
    end
end

function DecorManager:SelectItem(item)
	if self.currentSelect == item then
		self:DeSelectItem()
		return
	end

	self:DeSelectItem()

	item.transform:SetLocalScale(selectSize)
	self.currentSelect = item
end

function DecorManager:DeSelectItem()
	if self.currentSelect ~= nil then
		self.currentSelect.transform:SetLocalScale(deselectSize)
		self.currentSelect = nil
	end
end

function DecorManager:HandleActionButton()
	if self.currentSelect == nil then
		self.actionButton:SetInteractable(false)
	else
		self.actionButton:SetInteractable(true)
	end
end

-- Set sprite để đặt ra
function DecorManager:SetFunctionActionButton(data)
	self.actionButton:onClickRemoveAll()
	self.actionButton:onClickAddListener(function ()
		AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
		self.placeManager:EquipDecor(false, data)
	end)
end

_G.DecorManager = DecorManager