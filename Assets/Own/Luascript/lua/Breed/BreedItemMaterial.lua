---@class BreedItemMaterial : MonoBehaviour
---@field imgLock Image
---@field imgMaterial Image
local BreedItemMaterial = class("BreedItemMaterial", MonoBehaviour)
BreedItemMaterial.__path = __path

function BreedItemMaterial:Lock(lock)
    self.lock = lock
    self.imgLock.gameObject:SetActive(lock)
end

function BreedItemMaterial:OnClick()
    if self.isHasMaterial then
        ---@type Popup_breed
        local parent = self.parent
        parent:MaterialOnReturn(self)
    end
end

---@param material _BagItem
function BreedItemMaterial:UseMaterial(material)
    self.isHasMaterial = true
    self.material = material
    self.imgMaterial:SetSprite(material:GetSprite())
    self.imgMaterial.gameObject:SetActive(true)
end

function BreedItemMaterial:ReturnMaterial()
    self.imgMaterial.gameObject:SetActive(false)
    self.isHasMaterial = false
    return self.material
end

function BreedItemMaterial:RemoveMaterial()
    self.imgMaterial.gameObject:SetActive(false)
    self.isHasMaterial = false
    self.material = nil
end

_G.BreedItemMaterial = BreedItemMaterial
