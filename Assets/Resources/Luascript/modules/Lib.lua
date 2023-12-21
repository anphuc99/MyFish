Lib = {}

Lib.ListComponent = {}
Lib.ListClassName = {}
Lib.ListGameObject = {}
Lib.ListTransform = {}

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
---@param InstanceIDGameObject number
---@param obj Component
function Lib.RegisterComponent(InstanceIDGameObject, obj)
    if Lib.ListComponent[InstanceIDGameObject] == nil then
        Lib.ListComponent[InstanceIDGameObject] = {}
    end
    print(InstanceIDGameObject, obj.__cname)
    table.insert(Lib.ListComponent[InstanceIDGameObject], obj)
end
---@param InstanceIDGameObject number
---@param obj Component
function Lib.UnRegisterComponent(InstanceIDGameObject, obj)
    for index, value in ipairs(Lib.ListComponent[InstanceIDGameObject]) do
        if value == obj then
            table.remove(Lib.ListComponent[InstanceIDGameObject], index)
            break
        end
    end
end
---@param InstanceID number
---@param classname string
---@return Component
function Lib.GetComponent(InstanceID, classname)
    for index, value in ipairs(Lib.ListComponent[InstanceID]) do
        if (Lib.CheckTypeClass(classname, value)) then            
            return value
        end
    end
end

---@param InstanceID number
function Lib.RemoveInstanceComponent(InstanceID)
    Lib.ListComponent[InstanceID] = nil
end

---@return boolean
function Lib.CheckTypeClass(classname, obj)    
    if obj.__cname == classname then
        return true
    elseif obj.super ~= nil then
        return Lib.CheckTypeClass(classname, obj.super)
    else
        return false
    end
end

function Lib.AddClass(classname, cls)    
    Lib.ListClassName[classname] = cls
end

function Lib.GetClass(classname)        
    return Lib.ListClassName[classname]
end

function Lib.GetOrAddGameObject(InstanceIDGameObject)
    if not Lib.ListGameObject[InstanceIDGameObject] then
        local gameObject = GameObject.new(InstanceIDGameObject)
        Lib.ListGameObject[InstanceIDGameObject] = gameObject
    end

    return Lib.ListGameObject[InstanceIDGameObject]
end

function Lib.GetOrAddTransform(InsTransform, InstanceIDGameObject)    
    if not Lib.ListTransform[InsTransform] then
        local transform = Transform.new(InsTransform)
        transform:Init(InstanceIDGameObject);        
        Lib.ListTransform[InsTransform] = transform
    end
    return Lib.ListTransform[InsTransform]
end

function Lib.SetObject(classname, InstanceID, InstanceIDGameObject, InsTransform ,initparam)
    local obj = Lib.GetClass(classname).new(InstanceID,InstanceIDGameObject);

    obj.transform = Lib.GetOrAddTransform(InsTransform, InstanceIDGameObject)

    if initparam then
        for key, value in pairs(initparam) do
            obj[key] = value
        end               
    end
    obj:Init(InstanceIDGameObject);
    return obj
end