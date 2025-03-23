---@class AquariumSocket
local AquariumSocket = class("AquariumSocket")

function AquariumSocket:GetAquarium(callback, UUID)
    local packet = { cmd = UUID and "get_other" or "get", UUID = UUID }
    ServerHandler:SendMessage(Enum.Socket.AQUARIUM_DATA, packet, function(resp)
        local inform = resp.data.list
        if resp.code == 1 then
            Me:InitAquarium(inform, UUID)
            if callback then
                callback({ code = resp.code, inform = inform })
            end
        end
    end)
end

---@param aquarium number
---@param itemid string
---@param amount number
function AquariumSocket:CollectDropItem(aquarium, itemid, amount, callback)
    local packet = {
        cmd = "drop_item",
        data = {
            type = "get",
            aquarium = aquarium,
            itemid = tostring(itemid),
            amount = amount
        }
    }
    ServerHandler:SendMessage(Enum.Socket.AQUARIUM_DATA, packet, function(resp)
        if callback then
            callback(resp)
        end
        return resp.code
    end)
end

function AquariumSocket:EquipDecor(data, callBack)
    local query = {
        cmd = "equip",
        aquarium = data.index,
        data = {
            x = data.x,
            y = data.y,
        },
        UID = data.UID
    }
    ServerHandler:SendMessage(Enum.Socket.DECORATION_DATA, query, function(resp)
        if callBack then
            callBack(resp)
        end
    end)
end

function AquariumSocket:UnequipDecor(id, callBack)
    local query = {
        cmd = "unequip",
        id = id
    }
    ServerHandler:SendMessage(Enum.Socket.DECORATION_DATA, query, function(resp)
        if callBack then
            callBack(resp)
        end
    end)
end

function AquariumSocket:GetDecorations(index, callBack)
    local query = {
        cmd = "get",
        aquarium = index,
    }
    ServerHandler:SendMessage(Enum.Socket.DECORATION_DATA, query, function(resp)
        if callBack then
            callBack(resp.data.list)
        end
    end)
end

function AquariumSocket:feedFish(idfood, listFish)    
    local data = {
        cmd = "feed",
        aquarium = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1,
        idfood = idfood,
        list = listFish
    }

    ServerHandler:SendMessage(Enum.Socket.AQUARIUM_DATA, data, function (resp)
        Lib.pv(resp)
    end)
end

function AquariumSocket:feedFriendFish(idfood, listFish, UUID, aquarium)
    local data = {
        cmd = "feed_other",
        aquarium = aquarium,
        UUID = UUID,
        idfood = idfood,
        list = listFish
    }
    Lib.pv(data)

    ServerHandler:SendMessage(Enum.Socket.AQUARIUM_DATA, data, function (resp)
        Lib.pv(resp)
    end)

end

function AquariumSocket:CollectFriendDropItem(UUID, aquarium, itemid, amount, callback)
    local data = {
        cmd = "drop_item",
        data = {
            type = "get",
            aquarium = aquarium,
            itemid = itemid,
            UUID = UUID,
            amount = amount
        }
    }
    ServerHandler:SendMessage(Enum.Socket.AQUARIUM_DATA, data, function(resp)
        if callback then
            callback(resp)
        end
        return resp.code
    end)
end

_G.AquariumSocket = AquariumSocket