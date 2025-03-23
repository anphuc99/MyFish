---@class DropUpList : MonoBehaviour
---@field ItemList table
local DropUpList = class("DropUpList", MonoBehaviour)
DropUpList.__path = __path
function DropUpList:Awake()
    DropUpList.Instance = self
end

function DropUpList:GetItemByID(uid)    
    return self.ItemList[uid..""]
end

function DropUpList:GetTargetList(uid)
    return PlayerInfomation.Instance:GetPosUICurrency(uid)
end
_G.DropUpList = DropUpList
