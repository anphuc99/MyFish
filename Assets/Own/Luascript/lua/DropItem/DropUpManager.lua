
---@class DropUpManager : MonoBehaviour
local DropUpManager = class("DropUpManager", MonoBehaviour)
DropUpManager.__path = __path

function DropUpManager:Awake()
    DropUpManager.Instance = self
end

---@param target GameObject
---@param amount number
---@param aquarium number
---@param pos Vector3
function DropUpManager:CreateDropItem(uid, target, amount, aquarium, pos)
    if amount ~= amount then
        print("Coin is NaN")
        return
    end
    local newItem = self:Instantiate(DropUpList.Instance:GetItemByID(uid))
    if not newItem then
        return
    end
    newItem.transform:SetPosition(pos)
    ---@type ItemFlyUp
    local item = newItem:GetComponent("ItemFlyUp")
    print(self.__cname)
    item.parent = self
    if target then
        item:Initilize(target, uid, amount, aquarium)
    else 
        item:Initilize(DropUpList.Instance:GetTargetList(uid), uid, amount, aquarium)
    end
end

---@param target GameObject
---@param amount number
---@param pos Vector3
function DropUpManager:CreateFlyItem(uid, target, amount, pos)
    local newItem = self:Instantiate(DropUpList.Instance:GetItemByID(uid))
    newItem.transform:SetPosition(pos)
    local item = newItem:GetComponent("ItemFlyUp")
    item.parent = self
    if target then
        item:Initilize1(target, uid, amount)
    else
        item:Initilize1(DropUpList.Instance:GetTargetList(uid), uid, amount)
    end
    item:Fly()
end

function DropUpManager:FlyComplete(Fly)
    AquariumSocket:CollectDropItem(Fly.aquarium, Fly.itemId, math.ceil(Fly.amount), function(resp)
        Lib.pv(resp)
    end)
end

_G.DropUpManager = DropUpManager
