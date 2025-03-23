---@class StringFormat : MonoBehaviour
local StringFormat = class("StringFormat", MonoBehaviour)
StringFormat.__path = __path

function StringFormat:Number(number)
    if number < 1000 then
        return number
    end

    local text = tostring(number)
    local myTable =  {}

    for i = 1, #text, 3 do
        table.insert(myTable, string.sub(text:reverse(), i, i + 2))
    end

    return table.concat(myTable, ","):reverse()
end

function StringFormat:Time(number)
    local result = {}
    local hours = number / 3600
    local minutes = number % 3600 / 60
    local seconds = number % 3600 % 60

    if hours < 10 then
        hours = "0" .. hours
    end

    if minutes < 10 then
        minutes = "0" .. minutes
    end
    
    if seconds < 10 then
        seconds = "0" .. seconds
    end

    if hours ~= 0 then
        table.insert(result, hours .. ":")
    end

    if minutes ~= 0 then
        table.insert(result, minutes .. ":")
    end

    if seconds ~= 0 then
        table.insert(result, seconds)
    end

    return table.concat(result, "")
end

_G.StringFormat = StringFormat