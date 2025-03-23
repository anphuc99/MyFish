---@class PlaceManager : MonoBehaviour
---@field placeItem PlaceItem
---@field root Transform
---@field currentAmountText TextMeshProGUI
---@field boundBar RectTransform
local PlaceManager = class("PlaceManager", MonoBehaviour)
PlaceManager.__path = __path

function PlaceManager:Start()
    self.currentAmount = 0
    self.maxAmount = Me:get_player():get().max_slot_decoration - 1
end

function PlaceManager:LoadDecor()
    AquariumSocket:GetDecorations(1, function (data)
        for index, value in pairs(data) do
            self:EquipDecor(true, value)
        end
        self:CancelDecor()
    end)
end

function PlaceManager:DestroyAllDecors()
    for index, value in pairs(self.root:GetAllChild()) do
        self:Destroy(value.gameObject)
        self:DecreaseCurrentAmount()
    end
end

function PlaceManager:EquipDecor(firstLoad, data)
    local id = data.id ~= nil and data.id or 0
    local x = data.data ~= nil and data.data.x or 0
    local y = data.data ~= nil and data.data.y or 0
    local position = Vector3.new(x, y, 0)
    local sprite = DataManager.Instance:GetDecorationSprite(data.UID)

    if self.currentAmount == self.maxAmount then
        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = "Đã hết chỗ chứa!",
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

    ---@type PlaceItem
    local placeItem = self:Instantiate(self.placeItem)
    placeItem.transform:SetParent(self.root)
    placeItem.transform:SetLocalPosition(position)
    placeItem.thumbnail:SetSprite(sprite)
    placeItem.UID = data.UID
    placeItem.id = id
    placeItem.removeButton:onClickAddListener(function ()
        Event:Emit(Constant.Event.OnAddDecorItem, tonumber(data.UID))
        self:Destroy(placeItem.gameObject)

        self:DecreaseCurrentAmount()
        self:UpdateCurrentAmountText()
    end)

    if not firstLoad then
        Event:Emit(Constant.Event.OnSubtractDecorItem, data.UID)
    end

    self:IncreaseCurrentAmount()
    self:UpdateCurrentAmountText()
end

function PlaceManager:HandleSave()
    self:UnsaveOnServer()
end

function PlaceManager:SaveOnServer()
    for index, value in pairs(self.root:GetAllChild()) do
        ---@type PlaceItem
        local placeItem = value:GetComponent("PlaceItem")

        AquariumSocket:EquipDecor({
            index = 1,
            x = placeItem.transform:GetLocalPosition().x,
            y = placeItem.transform:GetLocalPosition().y,
            UID = placeItem.UID
        }, function (resp)
            if resp.code ~= 3 then
                PopupManager:show(Constant.PoppupID.Popup_Notification, {
                    title = "THÔNG BÁO",
                    desrciption = resp.msg,
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
            else
                -- id này là duy nhất của mỗi đồ trang trí
                placeItem.id = tonumber(resp.data.id)
            end
        end)
    end
end

function PlaceManager:UnsaveOnServer()
    AquariumSocket:GetDecorations(1, function (data)
        local amount = #data
        if amount == 0 then
            self:SaveOnServer()
            return
        end
        AquariumSocket:UnequipDecor(data[amount].id, function (resp)
            self:UnsaveOnServer()
        end)
    end)
end

function PlaceManager:IncreaseCurrentAmount()
    self.currentAmount = self.currentAmount + 1
end

function PlaceManager:DecreaseCurrentAmount()
    self.currentAmount = self.currentAmount - 1
end

function PlaceManager:UpdateCurrentAmountText()
    self.currentAmountText:SetText(self.currentAmount .. "/" .. self.maxAmount)
end

function PlaceManager:SetUpBoundBar()
    local placeItemSizeDelta = 150
    local screenPercentage = 0.3
    local additionalHeight = 3 * placeItemSizeDelta / 2 + 30

    local y = Screen:GetHeight() / 2 * screenPercentage
    local localY = y + additionalHeight
    self.boundBar:SetAnchoredPosition(Vector3.new(0, localY, 0))
end

function PlaceManager:EditDecor()
	for index, value in pairs(self.root:GetAllChild()) do
        ---@type PlaceItem
        local placeItem = value:GetComponent("PlaceItem")
        placeItem.removeButton.gameObject:SetActive(true)
        placeItem:SetEnableDrag()
    end
end

function PlaceManager:CancelDecor()
	for index, value in pairs(self.root:GetAllChild()) do
        ---@type PlaceItem
        local placeItem = value:GetComponent("PlaceItem")
        placeItem.removeButton.gameObject:SetActive(false)
        placeItem:SetDisableDrag()
    end
end

_G.PlaceManager = PlaceManager