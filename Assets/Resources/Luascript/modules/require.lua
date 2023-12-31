local cache = {}
local isCall = {}

oldRequire = require

require = function (path)
    if Unity.IsEditor then
        return Unity.require(path)
    end
    if not isCall[path] then
        local rs = table.pack(Unity.require(path))
        cache[path] = rs
        isCall[path] = true
        return table.unpack(cache[path])        
    else
        return table.unpack(cache[path])
    end
end