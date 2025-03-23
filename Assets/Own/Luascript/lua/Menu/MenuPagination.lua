---@class MenuPagination : MonoBehaviour
---@field leftArrow GameObject
---@field rightArrow GameObject
local MenuPagination = class("MenuPagination", MonoBehaviour)
MenuPagination.__path = __path

local page = 6
local firstOrder = 1
local left = firstOrder
local right = page

function MenuPagination:ShowPage()
    local features = MenuManager.Instance.features
    for index, value in pairs(features) do
        if index < left or index > right then
            value:SetActive(false)
        else
            value:SetActive(true)
        end
    end
end

function MenuPagination:NextPage()
    left = left + page
    right = right + page
    self:ShowPage()

    local featuresLength = #MenuManager.Instance.features
    if right >= featuresLength then
        self.rightArrow:SetActive(false)
        self:SetActiveArrow(self.leftArrow, true)
    end
end

function MenuPagination:BackPage()
    left = left - page
    right = right - page
    self:ShowPage()

    if left <= firstOrder then
        self.leftArrow:SetActive(false)
        self:SetActiveArrow(self.rightArrow, true)
        return
    end
end

---@param arrow GameObject
---@param isActive boolean
function MenuPagination:SetActiveArrow(arrow, isActive)
    if arrow:GetActive() ~= isActive then
        arrow:SetActive(isActive)
    end
end

_G.MenuPagination = MenuPagination