Time = {
    deltaTime = 0,
}

local dataTime = {}
local dataFrame = {}
local dataUpdate = {}
local idTimer = 0;

function Time:tick()
    for id, data in pairs(dataTime) do
        if data.time < 0 then
            local isLoop = data.func()
            if isLoop then                
                if isLoop ~= nil and type(isLoop) == "boolean" and isLoop then
                    data.time = data.startTime
                elseif type(isLoop) == "number" then
                    data.time = isLoop
                else
                    dataTime[id] = nil      
                end            
            else
                dataTime[id] = nil                
            end
        else
            data.time = data.time - Time.deltaTime
        end
    end

    for id, data in pairs(dataFrame) do
        if data.frame < 0 then
            local isLoop = data.func()
            if isLoop then
                if type(isLoop) == "boolean" and isLoop then
                    data.frame = data.startFrame
                elseif type(isLoop) == "number" then
                    data.frame = isLoop
                else
                    dataFrame[id] = nil
                end
            else
                dataFrame[id] = nil
            end
        else
            data.frame = data.frame - 1
        end
    end

    for func, value in pairs(dataUpdate) do
        func(value)
    end
end

---@param func function
function Time:startTimer(time, func)
    local id = idTimer
    dataTime[idTimer] ={
        func = func,
        startTime = time,
        time = time,        
    }
    idTimer = idTimer + 1
    return id
end

function Time:startFramer(frame, func)
    local id = idTimer
    dataFrame[idTimer] ={
        func = func,
        startFrame = frame,
        frame = frame,        
    }
    idTimer = idTimer + 1
    return id
end

function Time:stopTimer(id)
    dataTime[id] = nil
end

function Time:stopFramer(id)
    dataFrame[id] = nil
end

---@param func function
function Time:update(func, obj)
    dataUpdate[func] = obj or true
end

---@param func function
function Time:unUpdate(func)
    if dataUpdate[func]then
        print("Có xóa nha")
    end
    dataUpdate[func] = nil
end


