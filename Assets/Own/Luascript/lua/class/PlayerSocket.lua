---@class PlayerSocket
local PlayerSocket = class("PlayerSocket")

----- Lấy và cập nhập thông tin callback({code,inform})
---@param callback function
function PlayerSocket:getPlayer(callback, UUID)
    local packet = { cmd = UUID and "get_other" or "get", UUID = UUID }
    ServerHandler:SendMessage(Enum.Socket.LOAD_PLAYER, packet, function(resp)
        if callback then
            callback(resp)
        end
    end)
end

----- Tạo và cập nhập thông tin callback({code,inform})
---@param callback function
function PlayerSocket:create(username, gender, callback)
    local packet = { cmd = "create", data = { name = username, gender = gender } }
    ServerHandler:SendMessage(Enum.Socket.LOAD_PLAYER, packet, function(resp)
        if callback then
            callback(resp)
        end
    end)
end
----- Lấy và cập nhập thông tin callback({code,inform})
---@param callback function
function PlayerSocket:getMail(callback)
    local packet = { cmd = "get" }
    ServerHandler:SendMessage(Enum.Socket.MAIL, packet, function(resp)
        local inform = resp.data.list
        if resp.code == 1 then
          Me:InitMail(inform)
        end

        if callback then
            callback({ code = resp.code, inform = inform })
        end
    end)
end

function PlayerSocket:SignalPlayerChange()
    ServerHandler:On(Enum.Socket.CHANGE_SIGNAL.PLAYER, function(data)
        Event:Emit(Constant.Event.ServerChangePlayer, data)
    end)
end
_G.PlayerSocket = PlayerSocket