---@class QuestSocket
local QuestSocket = class("QuestSocket")


function QuestSocket:getDaily(callback)
    local data = {
        cmd = "get",
    }
    ServerHandler:SendMessage(Enum.Socket.DAILY, data, callback)
end

_G.QuestSocket = QuestSocket