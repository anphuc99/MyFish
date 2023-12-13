Time = {
    deltaTime = 0,
    fixedDeltaTime = 0
}

local dataTime = {}
local dataUpdate = {}
local dataFixedUpdate = {}
local idTimer = 0;

function Time:tick()
    for id, data in pairs(dataTime) do
        if data.time < 0 then
            data.func()
            if data.isLoop then
                data.time = data.startTime
            else
                dataTime[id] = nil
            end
        else
            data.time = data.time - Time.deltaTime
        end
    end

    for func, value in pairs(dataUpdate) do
        func(value)
    end
end

function Time:fixedTick()
    for func, value in pairs(dataFixedUpdate) do        
        func(value)
    end
end

---@param func function
function Time:start(func, time, isLoop)
    local id = idTimer
    dataTime[idTimer] ={
        func = func,
        startTime = time,
        time = time,
        isLoop = isLoop
    }
    idTimer = idTimer + 1
    return id
end

---@param func function
function Time:update(func, obj)
    dataUpdate[func] = obj or true
end

---@param func function
function Time:unUpdate(func)
    dataUpdate[func] = nil
end
---@param func function
function Time:fixedUpdate(func, obj)    
    dataFixedUpdate[func] = obj or true
end
---@param func function
function Time:unFixedUpdate(func)
    dataFixedUpdate[func] = nil
end