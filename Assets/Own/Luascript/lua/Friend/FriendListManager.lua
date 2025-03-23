---@class FriendListManager : MonoBehaviour
---@field menu GameObject
---@field content Transform
---@field friendItem FriendItem
local FriendListManager = class("FriendListManager", MonoBehaviour)
FriendListManager.__path = __path

function FriendListManager:Awake()
    self.evUpdateFriend = Event:Register(Constant.Event.UpdateFriend, Lib.handler(self, self.UpdateFriend))
    FriendListManager.Instance = self
    self.isOpen = false
end

function FriendListManager:Start()
    self.listFriend = {}
    self:Refresh()
end

function FriendListManager:Toggle()
    local postion
    local curPos = self.menu.transform:GetLocalPosition()
    if self.isOpen then
        postion = -196
        self.isOpen = false
    else
        postion = 196
        self.isOpen = true
    end
    LeanTween:moveLocalY(self.menu, postion + curPos.y, 0.2)
end

function FriendListManager:Refresh()
    local friends = Me:GetFriend()
    for index, value in pairs(friends) do            
        local friend = value
        if friend.isFriend then
            ---@type FriendItem
            local friendItem = self:InstantiateWithParent(self.friendItem, self.content)
            friendItem:SetFriend(friend)
            friendItem.parent = self
            table.insert(self.listFriend, friendItem)            
        end
    end
end

function FriendListManager:UpdateFriend()
    local friendUpdate
    local friends = Me:GetFriend()
    for index, value in pairs(friends) do            
        local friend = value
        local check = false
        for index, value2 in ipairs(self.listFriend) do
            if friend.isFriend and friend.friendCode == value2.friendData.friendCode then
                check = true
                break
            end
        end
        if not check and friend.isFriend then
            friendUpdate = friend
            break
        end
    end
    local friend = friendUpdate
    if friend then
        ---@type FriendItem
        local friendItem = self:InstantiateWithParent(self.friendItem, self.content)
        friendItem:SetFriend(friend)
        friendItem.parent = self
        table.insert(self.listFriend, friendItem)        
    end
end

function FriendListManager:ShowInfomation(data)
    PopupManager:show(Constant.PoppupID.Popup_InfoFriend, {data = data})
end

_G.FriendListManager = FriendListManager