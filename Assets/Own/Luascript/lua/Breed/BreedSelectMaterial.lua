---@class BreedSelectMaterial : MonoBehaviour
---@field imgMaterial Image
---@field amount TextMeshProGUI
local BreedSelectMaterial = class("BreedSelectMaterial", MonoBehaviour)
BreedSelectMaterial.__path = __path

---@param material _BagItem
function BreedSelectMaterial:SetMaterial(material)
    self.info = material
    self.imgMaterial.gameObject:SetActive(true)
    self.imgMaterial:SetSprite(self.info:GetSprite())
    self.amount:SetText(tostring(self.info.amount))
end

function BreedSelectMaterial:OnClick()
    if self.imgMaterial.gameObject:GetActive() then
        ---@type Popup_breed
        local parent = self.parent
        parent:MaterialOnSelect(self)        
    end
end

function BreedSelectMaterial:UserMaterial()
    local amount = tonumber(self.amount:GetText())
    amount = amount - 1
    if amount == 0 then
        self.imgMaterial.gameObject:SetActive(false)
    end
    self.amount:SetText(tostring(amount))
end

function BreedSelectMaterial:ReturnMaterial()
    self.imgMaterial.gameObject:SetActive(true)
    local amount = tonumber(self.amount:GetText())
    amount = amount + 1
    self.amount:SetText(tostring(amount))
end

_G.BreedSelectMaterial = BreedSelectMaterial
