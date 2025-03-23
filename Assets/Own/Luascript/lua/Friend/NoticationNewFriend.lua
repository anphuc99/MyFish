---@class NoticationNewFriend : MonoBehaviour
local NoticationNewFriend = class("NoticationNewFriend", MonoBehaviour)
NoticationNewFriend.__path = __path

function NoticationNewFriend:Awake()
    self.evNewFriendRequest = Event:Register(Constant.Event.UpdateNotify, Lib.handler(self, self.OnNewFriendRequest))
end

function NoticationNewFriend:Start()
    self:OnNewFriendRequest("friend")
end

function NoticationNewFriend:OnDestroy()
    Event:UnRegister(Constant.Event.UpdateNotify, self.evNewFriendRequest)
end

function NoticationNewFriend:OnNewFriendRequest(notify)
    if notify == "friend" then
        local friends = Me:GetFriend()
        local isHasNewFriend = false
        for key, friend in pairs(friends) do
            if not friend.isFriend then
                isHasNewFriend = true
                break
            end
        end
        self.gameObject:SetActive(isHasNewFriend)
    end
end

_G.NoticationNewFriend = NoticationNewFriend
