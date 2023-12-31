local create = coroutine.create
local running = coroutine.running
local resume = coroutine.resume
local yield = coroutine.yield
local status = coroutine.status

---@class Coroutine
Coroutine = {}


Coroutine.type = {
    waitForSecond = 1,
    waitForEndOfFrame = 2,
    waitUntil = 3,
    waitCoroutine = 4
}

Coroutine.listCo = {}

local idCo = 0

---@return Coroutine
function Coroutine.new()
    return setmetatable({}, {__index = Coroutine})
end

function Coroutine:start(f, ...)	
	local id = idCo
    idCo = idCo + 1
    local co = create(f)
    self.listCo[co] = id
    self:resume(co,nil,...)
    return id
end

function Coroutine:resume(co,callBack,...)
    local rs, Type, data = resume(co,...)            
    local Coroutine = self
    if rs then
        if status(co) == "suspended" and self.listCo[co] ~= nil then            
            if Type == self.type.waitForSecond then
                Time:startTimer(data.second, function ()
                    Coroutine:resume(co,callBack)
                end)
            elseif Type == self.type.waitForEndOfFrame then 
                Time:startFramer(data.frame, function ()
                    Coroutine:resume(co,callBack)
                end)     
            elseif Type == self.type.waitUntil then   
                Time:startFramer(1, function ()
                    local rs = data.func()
                    if rs then
                       Coroutine:resume(co,callBack)
                       return false 
                    end
                    return true
                end)
            elseif Type == self.type.waitCoroutine then
                local co2 = create(data.func)
                self.listCo[co2] = id
                Coroutine:resume(co2, function ()
                    Coroutine:resume(co, callBack)
                end, table.unpack(data.param))
            end
        elseif status(co) == "dead" then        
            if type(callBack) == "function" then
                callBack()
                self.listCo[co] = nil
            end    
        end
    else        
        self.listCo[co] = nil
        error(Type)        
    end
end

function Coroutine:WaitForSecond(second)
    yield(self.type.waitForSecond,{second = second})
end

function Coroutine:WaitForEndOfFrame(frame)
    yield(self.type.waitForEndOfFrame, {frame = frame})
end


function Coroutine:WaitUntil(func)
    yield(self.type.waitUntil, {func = func})
end

function Coroutine:WaitCoroutine(func,...)    
    yield(self.type.waitCoroutine, {func = func, param = {...}})
end

function Coroutine:stop(id)
    for key, value in pairs(self.listCo) do
        if value == id then
            self.listCo[key] = nil
        end
    end
end

function Coroutine:stopAll()
    self.listCo = {}
end

-- local function action(a,b)
--     print(a,b)
--     yield()
--     print(a,b)
-- end

-- local co = create(action)

-- resume(co,1,2)

-- print("start cor")

-- resume(co, 3,4)