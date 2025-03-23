---@class MailManager
local MailManager = class("MailManager")

function MailManager:ctor()
    MailManager.Instance = self
    ServerHandler:On(Enum.Socket.CHANGE_SIGNAL.MAIL, Lib.handler(self, self.NewMail))
end

function MailManager:NewMail(resp)
    Me:add_mail(resp)
    Event:Emit(Constant.Event.UpdateNotify, "mail")
end

_G.MailManager = MailManager
