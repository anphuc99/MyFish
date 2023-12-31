Lib = {}

Lib.ListComponent = {}
Lib.ListClassName = {}
Lib.ListGameObject = {}
Lib.ListTransform = {}
Lib.ListSprite = {}

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

function Lib.GetOrAddGameObject(InstanceIDGameObject, tag)
    if not Lib.ListGameObject[InstanceIDGameObject] then
        local gameObject = GameObject.new(InstanceIDGameObject)
        gameObject.tag = tag
        Lib.ListGameObject[InstanceIDGameObject] = gameObject
    end

    return Lib.ListGameObject[InstanceIDGameObject]
end

function Lib.GetOrAddTransform(InsTransform, InstanceIDGameObject, tag)    
    if not Lib.ListTransform[InsTransform] then
        local transform = Transform.new(InsTransform)
        transform.tag = tag
        transform:Init(InstanceIDGameObject);        
        transform.gameObject.transform = transform
        Lib.ListTransform[InsTransform] = transform        
    end
    return Lib.ListTransform[InsTransform]
end

function Lib.RemoveGameObject(InstanceIDGameObject)
    local gameObject = Lib.GetOrAddGameObject(InstanceIDGameObject)
    Lib.ListTransform[gameObject.transform:GetInstanceID()] = nil
    Lib.ListGameObject[InstanceIDGameObject] = nil
end

function Lib.GetOrAddSprite(InsSprite)
    if not Lib.ListSprite[InsSprite] then
        local sprite = Sprite.new(InsSprite)
        Lib.ListSprite[InsSprite] = sprite
    end
    return Lib.ListSprite[InsSprite]
end

function Lib.SetObject(classname, InstanceID, InstanceIDGameObject, InsTransform ,initparam, tag)        
    local obj = Lib.GetClass(classname).new(InstanceID,InstanceIDGameObject);
    obj.tag = tag

    obj.transform = Lib.GetOrAddTransform(InsTransform, InstanceIDGameObject, tag)

    if initparam then
        for key, value in pairs(initparam) do
            obj[key] = value
        end               
    end
    obj:Init(InstanceIDGameObject);
    return obj
end

function Lib.ExecuteFunction(obj, functionName,...)
    if(type(obj[functionName]) == "function") then
        return obj[functionName](obj,...)    
    end
end

function Lib.GetAttrObject(obj, attr)
    return obj[attr]
end

function Lib.SetAttrObject(obj, attr, value)
    obj[attr] = value
end

---@param obj Component
---@param path string
function Lib.RealTimeCompiler(obj,path)
    print(path)
    local cls = require(path)
    local c = cls.new()
    c:Update()
    obj:UniInit()
    print("co có")
    for key, value in pairs(c) do
        if type(value) == "function" then
            print("sao lay được không ")
            obj[key] = value
        end
    end
    obj:Update()
    obj:OnInit()
    if type(obj.Update) == "function" then            
        if obj.gameObject:GetActive() then
            obj:DisableUpdate()
            obj:EnableUpdate()                    
        end
    end
end