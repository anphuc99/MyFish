---@class FriendManager 
local FriendManager = class("FriendManager")

function FriendManager:ctor()
    FriendManager.Instance = self    
    ServerHandler:On(Enum.Socket.CHANGE_SIGNAL.NEW_REQUEST_FRIEND, function (resp)
        Me:AddFriend(resp, resp.status == Constant.FriendStatus.Accepted)
        Event:Emit(Constant.Event.UpdateNotify, "friend")
        Event:Emit(Constant.Event.UpdateFriend)
    end)
end

_G.FriendManager = FriendManager