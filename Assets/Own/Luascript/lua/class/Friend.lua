---@class Friend 
local Friend = class("Friend")

function Friend:ctor(value, isFriend)
    self.friendCode = value.friendCode
    self.level = value.level
    self.gender = value.gender
    self.name = value.name
    self.UUID = value.UUID
    self.avatar = value.avatar
    self.isFriend = isFriend
    self.status = value.status

    self.listBind = {}
    ServerHandler:On(Enum.Socket.CHANGE_SIGNAL.PLAYER_ONLINE..self.UUID, function (resp)
        self.status = resp.status
        Event:Emit(Constant.Event.PLAYER_ONLINE..self.UUID, resp)
    end)
end

function Friend:GetAvatar(callback)
    Sprite:CreateSpriteFromURL(self.avatar, callback)
end

function Friend:SetFriend()
    self.isFriend = true
end

_G.Friend = Friend