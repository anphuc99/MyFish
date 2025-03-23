
---@class DropUpFriendManager : DropUpManager
local DropUpFriendManager = class("DropUpFriendManager", DropUpManager)
DropUpFriendManager.__path = __path

function DropUpFriendManager:FlyComplete(Fly)
    AquariumSocket:CollectFriendDropItem(Me:get_player().UUID ,Fly.aquarium, Fly.itemId,math.ceil(Fly.amount),function (resp)
        Lib.pv(resp)
    end)
end
_G.DropUpFriendManager = DropUpFriendManager
