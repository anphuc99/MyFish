---@class MailItemPrefab : MonoBehaviour
---@field icon Image
---@field amount TextMeshProGUI
local MailItemPrefab = class("MailItemPrefab", MonoBehaviour)
MailItemPrefab.__path = __path

local function formatCurrency(amount)
    local formattedAmount = tostring(amount)
    formattedAmount = string.reverse(formattedAmount)
    formattedAmount = string.gsub(formattedAmount, "(%d%d%d)", "%1,")
    formattedAmount = string.reverse(formattedAmount)
    formattedAmount = string.gsub(formattedAmount, "^,", "")
    return formattedAmount
end

function MailItemPrefab:Awake()
   
end

function MailItemPrefab:OnDestroy()
   
end

function MailItemPrefab:Start()
   
end

function MailItemPrefab:SetData(uid_item,amount)
    ---@type Sprite
    local sprite=DataManager.Instance:GetItemSprite(uid_item)
    self.icon:SetSprite(sprite)
    self.amount:SetText(formatCurrency(amount))

end


function MailItemPrefab:Update()    
    
   
end

function MailItemPrefab:OnMouseDown()
  
   
end
function MailItemPrefab:MailDelete()
    self:Destroy()
end

_G.MailItemPrefab = MailItemPrefab