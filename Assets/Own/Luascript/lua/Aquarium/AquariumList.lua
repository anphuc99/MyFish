---@class AquariumList : MonoBehaviour
---@field item1 AquariumItem
---@field item2 AquariumItem
---@field item3 AquariumItem
local AquariumList = class("AquariumList", MonoBehaviour)
AquariumList.__path = __path
function AquariumList:Awake()    
    self:Refresh()
end

function AquariumList:Refresh()
    self.curAquarium = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1
    for i = 1, Constant.MAX_AQUARIUM, 1 do
        ---@type AquariumItem
        local aquariumItem = self["item"..i]
        aquariumItem.index = i
        aquariumItem:UnSelect()
    end
    ---@type AquariumItem
    local aquariumItem = self["item"..self.curAquarium]
    aquariumItem:Select()

    local countAquarium = Me:CountAquarium()
    for i = 1, Constant.MAX_AQUARIUM, 1 do
        ---@type AquariumItem
        local aquariumItem = self["item"..i]
        aquariumItem:Lock(i > countAquarium)
    end
end

_G.AquariumList = AquariumList
