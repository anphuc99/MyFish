Lib.CheckGlobal("MasterSocket")
MasterSocket = {}

MasterSocket.data = {}

function MasterSocket:GetMaster(master, callBack)
    local query = { cmd = "get", type = master }
    ServerHandler:SendMessage(Enum.Socket.MASTER, query, function(resp)
        self.data[master] = resp
        DataLocalManager:SetCache(master, resp)
        callBack(resp)
    end)
end