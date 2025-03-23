CsEvent = {}

function CsEvent:Register(nameEvent, callback)
    return APILuaEvent.Register(nameEvent, callback)
end

function CsEvent:UnRegister(nameEvent, eventID)
    APILuaEvent.UnRegister(nameEvent, eventID)
end

function CsEvent:Emit(nameEvent, value)
    APILuaEvent.Emit(nameEvent, value)
end