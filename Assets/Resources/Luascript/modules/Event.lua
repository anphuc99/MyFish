Event = {}

local eventID = 0

Event.listEvent = {}
Event.listRequest = {}

function Event:Register(eventName, func)
    if not Event.listEvent[eventName] then
        Event.listEvent[eventName] = {}
    end    
    local id = eventID
    eventID = eventID + 1
    Event.listEvent[eventName][id] = func
    return id
end

function Event:UnRegister(eventName,id)
    if Event[eventName] then
        Event[eventName][id] = nil
    end
end

function Event:Emit(eventName,...)
    if Event[eventName] then
        for key, func in pairs(Event[eventName]) do
            func(...)
        end
    end
end

function Event:RegisterRequestData(requestName, func)
    Event.listRequest[requestName] = func
end

function Event:RequestData(requestName,param,callback)    
    if Event.listRequest[requestName] then
        Event.listEvent[requestName](param,callback)
    end
end