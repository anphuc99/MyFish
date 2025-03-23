Lib.CheckGlobal("QuestsSocket")

QuestsSocket = {}

function QuestsSocket:getDaily(callback)
    local data = {
        cmd = "get",
    }
    ServerHandler:SendMessage(Enum.Socket.DAILY, data, callback)
end
