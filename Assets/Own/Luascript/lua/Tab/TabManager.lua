---@class TabManager : MonoBehaviour
---@field defaultTab GameObject
---@field activeTab GameObject
---@field activeSprite Sprite
---@field inactiveSprite Sprite
---@field tabs table
local TabManager = class("TabManager", MonoBehaviour)
TabManager.__path = __path

local whiteColor = Color.new(0.9725491, 0.9843138, 0.9843138)
local brownColor = Color.new(0.5245282, 0.4204935, 0.3077891)

local function GetTab(obj)
    return obj:GetComponent("Tab")
end

local function ChangeSprite(tab, sprite)
    tab.image:SetSprite(sprite)
end

local function ChangeTextColor(tab, color)
    tab.text:SetColor(color)
end

local function ChangeScroll(tab, bool)
    tab.scroll:SetActive(bool)
end

function TabManager:ResetContentPosition(tab)
    -- Lưu ý nếu có đổi gì trong UI thì phải xem lại thông số localPosition ở Inspector Debug
    -- Shop Vector3.new(-713, 0, 0)
    -- Bag Vector3.new(0, 445, 0)
    -- local position
    -- if self.tabType == "shop" then
    --     position = Vector3.new(-713, 0, 0)
    -- elseif self.tabType == "bag" then
    --     position = Vector3.new(0, 445, 0)
    -- end
    -- tab.content:SetLocalPosition(position)    
end

function TabManager:SetActiveTab(tab)
    self.activeTab = tab.gameObject
    
    local tab = GetTab(self.activeTab)
    ChangeSprite(tab, self.activeSprite)
    ChangeTextColor(tab, brownColor)
    ChangeScroll(tab, true)
end

function TabManager:SetInactiveTab()
    local tab = GetTab(self.activeTab)
    ChangeSprite(tab, self.inactiveSprite)
    ChangeTextColor(tab, whiteColor)
    ChangeScroll(tab, false)
    self:ResetContentPosition(tab)
end

---@param tab Tab
function TabManager:ChangeTab(tab,s)
    print(tab)
    if tab.gameObject == self.activeTab then
        return
    end
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self:SetInactiveTab()
    self:SetActiveTab(tab)
end

function TabManager:Start()
    for index, tab in pairs(self.tabs) do
        tab.button:onClickAddListener
        (
            function ()
                self:ChangeTab(tab)
            end
        )
    end
end

function TabManager:OnDestroy()
    for index, tab in pairs(self.tabs) do
        tab.button:onClickRemoveListener
        (
            function ()
                self:ChangeTab(tab)
            end
        )
    end
end

function TabManager:OnEnable()
    local tab = self.activeTab:GetComponent("Tab")
    print(self.defaultTab:GetName())
    -- local defaultTab = self.defaultTab:GetComponent("Tab")

    self:ResetContentPosition(tab)
    -- self:ChangeTab(defaultTab,"OnEnable")
end

_G.TabManager = TabManager