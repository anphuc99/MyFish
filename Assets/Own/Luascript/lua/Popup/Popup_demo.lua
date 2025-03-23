---@class Popup_demo : MonoBehaviour
---@field txt TextMeshProGUI
local Popup_demo = class("Popup_demo", MonoBehaviour)
Popup_demo.__path = __path

function Popup_demo:OnBeginShow()
    ---@type Player
    local player = Me:GetShopFish()
    self:showInfo(player)
end

---@param info Player
function Popup_demo:showInfo(info)    
    local str = ""
    for key, value in pairs(info) do
        local data = value:Get();        
        str = str..data.name.."\t"
    end
    self.txt:SetText(str)
end

function Popup_demo:OnEndShow()
    
end
function Popup_demo:OnBeginHide()
    
end
function Popup_demo:OnEndHide()
    
end

function Popup_demo:close()
    PopupManager:hide(self.PopupID)
end

_G.Popup_test = Popup_demo
