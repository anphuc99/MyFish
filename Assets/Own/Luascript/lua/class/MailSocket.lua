---@class MailSocket
local MailSocket = class("MailSocket")

function MailSocket:ReceiveMail(id, callback)
    local query = {
        cmd = "receive",
        id = id
    }
    ServerHandler:SendMessage(Enum.Socket.MAIL, query, function(resp)
        local code = resp.code
        if code==1 then
            Me:delete_mail_by_UUID(id)
            Event:Emit(Constant.Event.ReceiveMail,id)
            Event:Emit(Constant.Event.UpdateNotify,"mail")
            if callback then
                callback()
            end
        end
        
      
    end)
end



_G.MailSocket = MailSocket
