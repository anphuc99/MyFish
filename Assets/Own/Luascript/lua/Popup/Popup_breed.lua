---@class Popup_breed : MonoBehaviour
---@field fishItem BreedFishSelectItem
---@field fishMaleContent Transform
---@field fishFemaleContent Transform
---@field slotFemale Transform
---@field slotMale Transform
---@field slotStore table
---@field itemMaterial BreedSelectMaterial
---@field marterialContent Transform
---@field moneyCoin TextMeshProGUI
---@field effect GameObject
---@field progressRateOutLevel Slider
---@field numRateOutLevel TextMeshProGUI
local Popup_breed = class("Popup_breed", MonoBehaviour)
Popup_breed.__path = __path

function Popup_breed:OnBeginShow()
    self.fishItems = {}
    self.materialItems = {}
    self:RemoveFish()
    self:GetFish()
    self:UnLockUpgradeStone()
    self:RemoveMaterial()
    self:GetMaterial()
end

function Popup_breed:RemoveFish()
    local allChildMale = self.fishMaleContent:GetAllChild()
    local allChilFemale = self.fishFemaleContent:GetAllChild()
    for index, value in ipairs(allChildMale) do
        self:Destroy(value.gameObject)
    end
    
    for index, value in ipairs(allChilFemale) do
        self:Destroy(value.gameObject)
    end    
    self.fishItems = {}
end

function Popup_breed:GetFish()
    local index = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1
    local fishs = Me:get_fish_by_index(index)
    for key, value in pairs(fishs) do
        if value:isAdult() and not value:IsHungry() then
            if value:get().gender == Constant.Gender.Male then
                self:AddFishGender(value, self.fishMaleContent)
            else
                self:AddFishGender(value, self.fishFemaleContent)
            end            
        end
    end
end

---@param content Transform
function Popup_breed:AddFishGender(fish, content)
    ---@type BreedFishSelectItem
    local item = self:InstantiateWithParent(self.fishItem, content)
    item:SetFish(fish)
    item.parent = self
    table.insert(self.fishItems, item)
end

function Popup_breed:OnSelectFish(item)
    for index, value in ipairs(self.fishItems) do
        value:OnSelect(item)
    end
    self:RefreshInfoBreed()
end

function Popup_breed:UnLockUpgradeStone()
    local player = Me:get_player()
    local lv = player:get().lv_level
    local slotOpen = self:CalculateOpenSlot(lv) 
    for index, value in pairs(self.slotStore) do
        local i = tonumber(index)
        ---@type BreedItemMaterial
        local itemMaterial = value
        itemMaterial:RemoveMaterial()
        if i <= slotOpen then
            itemMaterial:Lock(false)
        else
            itemMaterial:Lock(true)
        end
        itemMaterial.parent = self
    end
end

function Popup_breed:CalculateOpenSlot(level)    
    local openCells = math.floor(level / 5) + 1
    if openCells > 9 then
        openCells = 9
    end
    
    return openCells
end

function Popup_breed:RemoveMaterial()
    local allChildMaterial = self.marterialContent:GetAllChild()
    for index, value in ipairs(allChildMaterial) do
        self:Destroy(value.gameObject)
    end
    self.materialItems = {}
end

function Popup_breed:GetMaterial()
    local bag = Me:GetBagItem()
    local count = 0
    for key, value in pairs(bag) do
        if value:GetInfo().type == 3 then
            ---@type BreedSelectMaterial
            local item = self:InstantiateWithParent(self.itemMaterial, self.marterialContent)
            item:SetMaterial(value)
            item.parent = self
            count = count + 1
            table.insert(self.materialItems, item)
        end
    end

    for i = 1, 5 - count % 5, 1 do
        self:InstantiateWithParent(self.itemMaterial, self.marterialContent)
    end
end

function Popup_breed:MaterialOnSelect(item)
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self:UserMaterial(item)
end

function Popup_breed:MaterialOnReturn(slot)
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self:ReturnMaterial(slot)
end

---@param item BreedSelectMaterial
function Popup_breed:UserMaterial(item)
    for key, value in pairs(self.slotStore) do
        ---@type BreedItemMaterial
        local slot = value
        if not slot.isHasMaterial and not slot.lock then
            slot:UseMaterial(item.info)
            item:UserMaterial()
            break
        end
    end
    self:RefreshInfoBreed()
end

---@param slot BreedItemMaterial
function Popup_breed:ReturnMaterial(slot)
    for key, value in pairs(self.materialItems) do
        ---@type BreedFishSelectItem
        local item = value
        if item.info == slot.material then
            item:ReturnMaterial()
            slot:ReturnMaterial()
            break
        end
    end
    self:RefreshInfoBreed()
end

function Popup_breed:Close()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(self.PopupID)
end

function Popup_breed:OnBeginHide()
    for index, value in ipairs(self.fishItems) do
        value:OnClose()
    end
end

function Popup_breed:RefreshInfoBreed()
    self.moneyCoin:SetText(tostring(self:GetMoney()))
    local rate = self:GetProgressOutLevel()
    self.progressRateOutLevel:SetValue(rate)
    self.numRateOutLevel:SetText(tostring(rate))
end

function Popup_breed:GetMoney()
    local fishMaleSelected, fishFeleSelected = self:GetSelectFishBreed()
    if fishFeleSelected and fishMaleSelected then
        return math.ceil((fishFeleSelected.fish:GetInfo().price.coin + fishMaleSelected.fish:GetInfo().price.coin) * (30/100) / 2)
    end
    return 0
end

function Popup_breed:GetProgressOutLevel()
    local LocalPlayer = Me:get_player()
    local data = LocalPlayer:get()
    local fishMaleSelected, fishFeleSelected = self:GetSelectFishBreed()
    if not fishMaleSelected or not fishFeleSelected then
        return 0
    end

    local materialUse = self:GetMaterialUse()

    local MasterFemale = fishFeleSelected.fish:GetInfo()
    local MasterMale = fishMaleSelected.fish:GetInfo()

    local sumBreeds = MasterFemale.breed + MasterMale.breed
    local totalProbability = (sumBreeds ~= 0) and sumBreeds or 100
    local luckyValue = 0

    for index, value in pairs(materialUse) do
        local data = value.material:GetInfo().data
        luckyValue = luckyValue + data.value
    end
    local lv_average = math.ceil((MasterFemale.lv_required + MasterMale.lv_required) / 2)
    if (data.lv_level>=lv_average) then
        luckyValue=luckyValue+math.ceil(totalProbability * (1 / 4))
    end

    if luckyValue > totalProbability then
        luckyValue = totalProbability
    end
print(luckyValue,totalProbability)
    return math.ceil((luckyValue / totalProbability) * 100)
    
end

function Popup_breed:GetSelectFishBreed()
    ---@type BreedFishSelectItem
    local fishMaleSelected
    ---@type BreedFishSelectItem
    local fishFeleSelected
    for index, value in ipairs(self.fishItems) do
        ---@type BreedFishSelectItem
        local fishItem = value
        if fishItem.isBreed then
            if fishItem.fish:get().gender == Constant.Gender.Male then
                fishMaleSelected = fishItem
            else
                fishFeleSelected = fishItem
            end
        end
    end
    return fishMaleSelected, fishFeleSelected
end


function Popup_breed:GetMaterialUse()
    ---@type BreedItemMaterial[]
    local list = {}
    for key, value in pairs(self.slotStore) do
        ---@type BreedItemMaterial
        local itemMaterial = value
        if itemMaterial.isHasMaterial then
            table.insert(list, itemMaterial)
        end
    end
    return list
end

function Popup_breed:OnBreed()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    local fishMaleSelected, fishFeleSelected = self:GetSelectFishBreed()
    if not fishFeleSelected then
        Toat:Show("Chưa chọn giống cái", Constant.PoppupID.Popup_Toat)
        return
    end
    if not fishMaleSelected then
        Toat:Show("Chưa chọn giống đực", Constant.PoppupID.Popup_Toat)
        return
    end
    local materialUse = self:GetMaterialUse()
    local femaleid = fishFeleSelected.fish.id
    local maleid = fishMaleSelected.fish.id
    local listIdMaterial = {}
    for key, value in pairs(materialUse) do
        table.insert(listIdMaterial, value.material.UID)
    end
    self:showEffect()
    self:CheckTimeEffect()
    BreedSocket:OnBreed(femaleid, maleid, listIdMaterial, function (resp)
        self.result = resp.data
        for key, value in pairs(materialUse) do
            Event:Emit(Constant.Event.OnSubtractBagItem, value.material.UID)
            value:RemoveMaterial()
            self:RefreshInfoBreed()
        end
        self.isBreedComplete = true
    end)
end

function Popup_breed:CheckTimeEffect()
    local time = 3
    Time:startTimer(1, function ()
        if time < 0 and self.isBreedComplete then
            self:HideEffect()
            self.isBreedComplete = false
            return false
        else
            time = time - 1
            return true            
        end
    end)
end

function Popup_breed:showEffect()
    local fishMaleSelected, fishFeleSelected = self:GetSelectFishBreed()
    local anchorPotionMale = fishMaleSelected.createSlotFish:GetAnchoredPosition()
    local anchorPotionFemale = fishFeleSelected.createSlotFish:GetAnchoredPosition()
    LeanTween:value(0,20,2, function (value)
        fishFeleSelected.createSlotFish:SetAnchoredPosition(Vector3.new(anchorPotionFemale.x - value, anchorPotionFemale.y, anchorPotionFemale.z))
        fishMaleSelected.createSlotFish:SetAnchoredPosition(Vector3.new(anchorPotionMale.x + value, anchorPotionMale.y, anchorPotionMale.z))
    end)
    self.effect:SetActive(true)
    PopupManager:LockUI(true)
end

function Popup_breed:HideEffect()
    local fishMaleSelected, fishFeleSelected = self:GetSelectFishBreed()
    local anchorPotionMale = fishMaleSelected.createSlotFish:GetAnchoredPosition()
    local anchorPotionFemale = fishFeleSelected.createSlotFish:GetAnchoredPosition()
    fishFeleSelected.createSlotFish:SetAnchoredPosition(Vector3.new(anchorPotionFemale.x + 20, anchorPotionFemale.y, anchorPotionFemale.z))
    fishMaleSelected.createSlotFish:SetAnchoredPosition(Vector3.new(anchorPotionMale.x - 20, anchorPotionMale.y, anchorPotionMale.z))    
    self.effect:SetActive(false)
    PopupManager:LockUI(false)
    PopupManager:show(Constant.PoppupID.Popup_Reward, {
        ["1"] = {
            UID = self.result.item,
            amount = 1,
            name = self.result.fish.name
        }   
    })
    Event:Emit(Constant.Event.OnAddBagItem, tonumber(self.result.item))
end
_G.Popup_breed = Popup_breed
