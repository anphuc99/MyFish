---@class ChatTopbar : MonoBehaviour
---@field txtChat TextMeshProGUI
local ChatTopbar = class("ChatTopbar", MonoBehaviour)
ChatTopbar.__path = __path

function ChatTopbar:Awake()
    self.evOnServerSendChat = Event:Register(Constant.Event.OnServerSendChat, Lib.handler(self, self.OnServerSendChat))
end

function ChatTopbar:OnDestroy()
    Event:UnRegister(Constant.Event.OnServerSendChat, self.evOnServerSendChat)
end

function ChatTopbar:OnServerSendChat(resp)
    local channel = resp.channel
    local content = resp.content
    local Name = resp.name;
    local chat = "<color=red>[".. Constant.Chat.Chanel[channel].."]</color> " .. Name .. ": ".. content
    self.txtChat:SetText(chat)
end

_G.ChatTopbar = ChatTopbar
