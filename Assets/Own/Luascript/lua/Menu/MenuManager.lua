---@class MenuManager : MonoBehaviour
---@field featureContainer Transform
local MenuManager = class("MenuManager", MonoBehaviour)
MenuManager.__path = __path

function MenuManager:Awake()
    MenuManager.Instance = self
    self:GetFeaturesGameObject()
end

function MenuManager:GetFeaturesGameObject()
    self.features = {}
    local featureChildren = self.featureContainer:GetAllChild()
    for index, value in pairs(featureChildren) do
        table.insert(self.features, value.gameObject)
    end
end

---@param func function
function MenuManager:AddListenerOnClick(func)
    if not self.onClickBtn then
        self.onClickBtn = {}
    end    
    table.insert(self.onClickBtn, func)
end

function MenuManager:OnBtnMenuClick(btn)
    for index, value in ipairs(self.onClickBtn) do
        value(btn)
    end
end

_G.MenuManager = MenuManager