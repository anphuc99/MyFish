ServerHandler = {}

function ServerHandler:On(event, func)
    Unity.SocketIOOn(event, func)
end

function ServerHandler:SendMesseage(event, message, callback)
    Unity.SocketIOSendMessage(event, message, callback)
end