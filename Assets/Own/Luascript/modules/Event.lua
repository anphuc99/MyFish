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
    if id then
        if Event.listEvent[eventName] then
            Event.listEvent[eventName][id] = nil
        end        
    end
end

function Event:Emit(eventName,...)        
    if Event.listEvent[eventName] then
        for key, func in pairs(Event.listEvent[eventName]) do
            func(...)
        end
    end
end

function Event:RegisterRequestData(requestName, func)
    Event.listRequest[requestName] = func
end

function Event:RequestData(requestName,param,callback)    
    if Event.listRequest[requestName] then
        Event.listRequest[requestName](param,callback)
    end
end

function Event:RemoveRequestData(requestName)
    Event.listRequest[requestName] = nil
end