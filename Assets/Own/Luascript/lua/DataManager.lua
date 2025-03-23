---@class DataManager : MonoBehaviour
---@field fish table
---@field decoration table
---@field item table
---@field food table
local DataManager = class("DataManager", MonoBehaviour)
DataManager.__path = __path

function DataManager:Awake()
    DataManager.Instance = self
end

---@return Transform
function DataManager:GetFishSprite(UUID)
    for index, value in pairs(self.fish) do
        if index == tostring(UUID) then
            return value
        end
    end
    ---@type Transform
    return nil
end

function DataManager:GetDecorationSprite(UID)
    for index, value in pairs(self.decoration) do
        if index == tostring(UID) then
            return value
        end
    end
end

function DataManager:GetStallByUID(UID)
    return Me:GetItemByID(UID)	
end

function DataManager:GetBagItemTypeByUID(UID)
    if UID >= 141000 and UID < 142000 then
        return 1
    elseif UID >= 142000 and UID < 143000 then
        return 2
    end
end

function DataManager:GetItemSprite(UUID)
    for index, value in pairs(self.item) do
        if index == tostring(UUID) then
            return value
        end
    end
    return self.item["nil"]
end

function DataManager:GetFoodSprite(type)
    return self.food[tostring(type)]
end
_G.DataManager = DataManager