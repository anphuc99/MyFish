---@class ChatItem : MonoBehaviour
---@field txtName TextMeshProGUI
---@field txtContent TextMeshProGUI
---@field avatar Image
local ChatItem = class("ChatItem", MonoBehaviour)
ChatItem.__path = __path

function ChatItem:SetName(name)
    self.txtName:SetText(name)
end

function ChatItem:SetContent(content)
    self.txtContent:SetText(content)
end

function ChatItem:SetAvatar(linkAvatar)
    Sprite:CreateSpriteFromURL(linkAvatar, function (spr)
        self.avatar:SetSprite(spr)
    end)
end

_G.ChatItem = ChatItem
