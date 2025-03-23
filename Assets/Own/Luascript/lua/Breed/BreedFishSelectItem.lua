---@class BreedFishSelectItem : MonoBehaviour
---@field slotFish Transform
local BreedFishSelectItem = class("BreedFishSelectItem", MonoBehaviour)
BreedFishSelectItem.__path = __path

---@param fish Fish1
function BreedFishSelectItem:SetFish(fish)
    self.fish = fish     
    ---@type RectTransform
    local fish = self:InstantiateWithParent(DataManager.Instance:GetFishSprite(fish.UID), self.slotFish.transform)    
end

function BreedFishSelectItem:OnClick()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self.parent:OnSelectFish(self)
end

function BreedFishSelectItem:OnSelect(item)
    if item == self then
        self:OnSelectIsSelf()
    else
        self:OnOtherSelect(item)
    end
end

function BreedFishSelectItem:OnSelectIsSelf()
    self:AnimationFishMoveToBreed()
end

function BreedFishSelectItem:OnOtherSelect(item)
    if self.createSlotFish and item.fish:get().gender == self.fish:get().gender then
        self:AnimationFishMoveToSlot()        
    end
end

function BreedFishSelectItem:AnimationFishMoveToBreed()
    PopupManager:LockUI(true)
    local slotFish = self.slotFish
    ---@type Popup_breed
    local parent = self.parent
    local slotBreed
    if self.fish:get().gender == 1 then
        slotBreed = parent.slotMale
    else
        slotBreed = parent.slotFemale
    end

    ---@type RectTransform
    local createSlotFish = self:InstantiateWithParent(slotFish, parent.transform)
    createSlotFish.transform:SetPosition(slotFish:GetPosition())
    slotFish.gameObject:SetActive(false)

    LeanTween:move(createSlotFish.gameObject, slotBreed.transform:GetPosition(), 0.5)
        :setOnComplete(function ()
            PopupManager:LockUI(false)
        end)

    if self.fish:get().gender == Constant.Gender.Female then
        local scale = createSlotFish.transform:GetLocalScale()
        scale.x = -math.abs(scale.x)
        createSlotFish.transform:SetLocalScale(scale)
    end

    self.createSlotFish = createSlotFish
    self.isBreed = true
end

function BreedFishSelectItem:AnimationFishMoveToSlot()
    if not self.createSlotFish then
        return
    end
    PopupManager:LockUI(true)
    local slotFish = self.slotFish
    LeanTween:move(self.createSlotFish.gameObject, slotFish:GetPosition(), 0.5)
        :setOnComplete(function ()
            self:Destroy(self.createSlotFish.gameObject)
            slotFish.gameObject:SetActive(true)
            self.createSlotFish = nil
            self.isBreed = false
            PopupManager:LockUI(false)
        end)
end

function BreedFishSelectItem:OnClose()
    if self.createSlotFish then
        self:Destroy(self.createSlotFish.gameObject)     
        self.slotFish.gameObject:SetActive(true)   
    end
end

_G.BreedFishSelectItem = BreedFishSelectItem