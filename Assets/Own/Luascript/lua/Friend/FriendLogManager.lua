---@class FriendLogManager : MonoBehaviour
---@field friendLogItem FriendLogItem
---@field friendLogRoot Transform
local FriendLogManager = class("FriendLogManager", MonoBehaviour)
FriendLogManager.__path = __path

function FriendLogManager:LoadFriendLog()
    FriendSocket:GetFriendLog(function (logs)
        local oldMsg = #self.friendLogRoot:GetAllChild()
        local newMsg = #logs - oldMsg
        if newMsg == 0 then
            return
        end

        for i = oldMsg + 1, #logs, 1 do
            ---@type FriendLogItem
            local friendLogItem = self:Instantiate(self.friendLogItem)
            friendLogItem.transform:SetParent(self.friendLogRoot)
    
            local content = logs[i].friend_info.name .. " " .. logs[i].content
            local avatarLink = logs[i].friend_info.avatar
            local time = tostring(os.date('%d/%m/%Y %H:%M', math.floor(logs[i].created_at / 1000)))
            friendLogItem:SetInformation(avatarLink, content, time)
        end
    end)
end

_G.FriendLogManager = FriendLogManager