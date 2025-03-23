---@class ChatManager : MonoBehaviour
local ChatManager = class("ChatManager", MonoBehaviour)
ChatManager.__path = __path
ChatManager.dataChat = {}

function ChatManager:Awake()
    self.evOnServerSendChat = Event:Register(Constant.Event.OnServerSendChat, Lib.handler(self, self.OnServerSendChat))
    Event:RegisterRequestData(Constant.Request.DataChat, Lib.handler(self, self.RequestDataChat))
end

function ChatManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnServerSendChat, self.evOnServerSendChat)
    Event:RemoveRequestData(Constant.Request.DataChat)
end

function ChatManager:OnServerSendChat(resp)
    table.insert(ChatManager.dataChat,resp)
end

function ChatManager:RequestDataChat()
    return clone(ChatManager.dataChat)
end

_G.ChatManager = ChatManager
