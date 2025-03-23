---@class FriendRequestItem : MonoBehaviour
---@field imgAvatar Image
---@field name TextMeshProGUI
local FriendRequestItem = class("FriendRequestItem", MonoBehaviour)
FriendRequestItem.__path = __path

---@param friend Friend
function FriendRequestItem:SetFriend(friend)
    self.friend = friend
    self:SetAvatar()
    self:SetName()
end

function FriendRequestItem:SetAvatar()
    self.friend:GetAvatar(function (avatar)
        self.imgAvatar:SetSprite(avatar)
    end)
end

function FriendRequestItem:SetName()
    self.name:SetText(self.friend.name)
end

function FriendRequestItem:OnAcceptClick()
    self.parent:OnAccept(self)
end

function FriendRequestItem:OnRejectClick()
    self.parent:OnReject(self)
end

_G.FriendRequestItem = FriendRequestItem
