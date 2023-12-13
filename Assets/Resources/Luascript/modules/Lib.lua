Lib = {}

local ListComponent = {}

function Lib.handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

Lib.shuffle = function(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function Lib.splitString(str, sep, to_number)
	local res = {}
	string.gsub(str, '[^' .. sep .. ']+', function(w)
		if to_number then
			w = tonumber(w)
		end
		table.insert(res, w)
	end)
	return res
end

function Lib.dump(o)
    if type(o) == 'table' then
       local s = '{ \n'
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. Lib.dump(v) .. ',\n'
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function Lib.pv(t)
    print(Lib.dump(t))
end

function Lib.rotVector2(x0, y0, angle)
    local d = math.acos(x0)
    print(d)
    d = d + angle
    local x1 = math.cos(d)
    local y1 = math.sin(d)
    return x1, y1
end

function Lib.Func(f,...)
    local t = {...}
    return function()
        return f(table.unpack(t))
    end
end