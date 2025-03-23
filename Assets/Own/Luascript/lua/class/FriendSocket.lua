Lib.CheckGlobal("FriendSocket")
FriendSocket = {}

function FriendSocket:GetFriendRecommendation()
    
end

function FriendSocket:LookingFriend(friendCode, callback)
    local data = {
        cmd = "search",
        friendCode = friendCode
    }
    ServerHandler:SendMessage(Enum.Socket.FRIEND, data, function (resp)     
        callback(resp)
    end)
end

function FriendSocket:GetListFriend(callback)
    local data = {cmd = "getListFriend"}
    ServerHandler:SendMessage(Enum.Socket.FRIEND, data, function (resp)
        callback(resp)
    end)
end

function FriendSocket:GetRequestFriend(callback)
    local data = {cmd = "getRequestFriend"}
    ServerHandler:SendMessage(Enum.Socket.FRIEND, data, function (resp)
        callback(resp)
    end)
    
end

function FriendSocket:SendRequest(friendCode, callback)
    local data = {cmd = "sendRequest", friendCode = friendCode}
    ServerHandler:SendMessage(Enum.Socket.FRIEND, data, function (resp)
        callback(resp)
    end)
end

function FriendSocket:AcceptRequest(friendCode, callback)
    local data = {cmd = "acceptRequest", friendCode = friendCode}
    ServerHandler:SendMessage(Enum.Socket.FRIEND, data, function (resp)
        callback(resp)
    end)
end

function FriendSocket:RejectFriendship(friendCode, callback)
    local data = {cmd = "rejectFriendship", friendCode = friendCode}
    ServerHandler:SendMessage(Enum.Socket.FRIEND, data, function (resp)
        callback(resp)
    end)
end

function FriendSocket:GetFriendLog(callBack)
    local now = math.floor(os.time() * 1000)
    -- 7 ngày trước
    local startTime = now - 604800000
    -- Bây giờ
    local endTime = now

    local data = {
        cmd = "get",
        data = {
            start_time = startTime,
            end_time = endTime
        }
    }

    ServerHandler:SendMessage(Enum.Socket.FRIEND_LOG, data, function (resp)
        if callBack then
            callBack(resp.data.logs)
        end
    end)
end