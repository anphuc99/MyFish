Lib.CheckGlobal("ChatSocket")
ChatSocket = {}

function ChatSocket:SendChat(content, channel)
    local msg = {
        cmd = "chat",
        data = {
            channel = channel,
            content = content
        }
    }
    ServerHandler:SendMessage(Enum.Chat.CHAT, msg, function (resp)
        if resp.code == 1 then
            local dataChat = {
                UUID = Me:get_player().UUID,
                content = content,
                name = Me:get_player().properties.name,
                channel = channel
            }
            Event:Emit(Constant.Event.OnServerSendChat, dataChat)
        end
    end)
end

function ChatSocket:RegisterServerSendChat()
    ServerHandler:On(Enum.Chat.CHAT, Lib.handler(self, self.OnServerSendChat))
end

function ChatSocket:OnServerSendChat(resp)
    Event:Emit(Constant.Event.OnServerSendChat, resp)
end