---@class FriendRequestManager : MonoBehaviour
---@field friendItem FriendRequestManager
---@field content Transform
local FriendRequestManager = class("FriendRequestManager", MonoBehaviour)
FriendRequestManager.__path = __path

function FriendRequestManager:OnEnable()
    self:Refresh()
end

function FriendRequestManager:Refresh()
    self:RemoveFriendItem()
    self:GetFriend()
end

function FriendRequestManager:RemoveFriendItem()    
    local allChild = self.content:GetAllChild()
    for index, value in pairs(allChild) do
        self:Destroy(value.gameObject)
    end
end

function FriendRequestManager:GetFriend()
    local friends = Me:GetFriend()
    for key, value in pairs(friends) do
        ---@type Friend
        local friend = value
        if not friend.isFriend then
            ---@type FriendRequestItem
            local friendItem = self:InstantiateWithParent(self.friendItem, self.content)
            friendItem:SetFriend(friend)
            friendItem.parent = self
        end
    end
end

---@param friendItem FriendRequestItem
function FriendRequestManager:OnAccept(friendItem)
    FriendSocket:AcceptRequest(friendItem.friend.friendCode, function (resp)
        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = "Kết bạn thành công! bạn và "..friendItem.friend.name.." đã là bạn",
            btnYes = {
                text = "Đồng Ý",
                onClick = function()
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                end
            },
            btnNo = {
                disable = true
            }
        })
        friendItem.friend:SetFriend()
        Event:Emit(Constant.Event.UpdateFriend)
        Event:Emit(Constant.Event.UpdateNotify, "friend")
        self:Destroy(friendItem.gameObject)
    end)
end

function FriendRequestManager:OnReject(friendItem)
    FriendSocket:RejectFriendship(friendItem.friendItem.friendCode, function ()
        Me:RemoveFriend(friendItem.friendItem.friendCode)
        self:Destroy(friendItem.gameObject)
        Event:Emit(Constant.Event.UpdateFriend)
    end)
end

_G.FriendRequestManager = FriendRequestManager
