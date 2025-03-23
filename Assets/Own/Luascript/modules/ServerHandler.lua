ServerHandler = {}

---@param event string
---@param func function
function ServerHandler:On(event, func)
    APISocketIO.On(event, func)
end

---@param event string
function ServerHandler:Off(event)
    APISocketIO.Off(event)
end

---@param event string
---@param message table
function ServerHandler:SendMessage(event, message, callback)
    APISocketIO.SendMessage(event, message, callback)
end

---@param url string
---@param data table
function ServerHandler:SendHTTP(url, data, callback, callbackError)
    Unity.SocketIOHttp(url, data, callback, callbackError)
end