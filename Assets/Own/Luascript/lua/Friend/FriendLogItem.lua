---@class FriendLogItem : MonoBehaviour
---@field avatar Image
---@field content TextMeshProGUI
---@field time TextMeshProGUI
local FriendLogItem = class("FriendLogItem", MonoBehaviour)
FriendLogItem.__path = __path

---@param avatarLink string
---@param content string
---@param time string
function FriendLogItem:SetInformation(avatarLink, content, time)
    Sprite:CreateSpriteFromURL(avatarLink, function (sprite)
        self.avatar:SetSprite(sprite)
    end)
    self.content:SetText(content)
    self.time:SetText(time)
end

_G.FriendLogItem = FriendLogItem