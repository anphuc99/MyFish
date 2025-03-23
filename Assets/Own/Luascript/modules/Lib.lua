Lib = {}

Lib.ListComponent = {}
Lib.ListClassName = {}
Lib.ListGameObject = {}
Lib.ListTransform = {}
Lib.ListSprite = {}
Lib.ListAudioClip = {}

---@return function
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

function Lib.dumpClass(o, level)
    level = level or 0
    local indent = string.rep('\t', level)
    if type(o) == 'table' then
        local s = '{\n'
        for k, v in pairs(o) do
            if k ~= "__index" then
                if type(k) ~= 'number' then
                    k = '"' .. k .. '"'
                end
                s = s .. indent .. '[ ' .. k .. ' ] = ' .. Lib.dumpClass(v, level + 1) .. ',\n'                
            end
        end
        s = s .. string.rep('\t', level - 1) .. '}'
        return s
    else
        return tostring(o)
    end
end

function Lib.dumpTag(o, level)
    level = level or 0
    local indent = string.rep('<t>', level)
    if type(o) == 'table' then
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. indent .. '[ ' .. k .. ' ] = ' .. Lib.dumpClass(v, level + 1) .. ',\n'
        end
        s = s .. string.rep('<t>', level - 1) .. '}'
        return s
    else
        return tostring(o)
    end
end

function Lib.pv(t)
    if t.__cname then
        print(Lib.dumpClass(t))
    else
        print(Lib.dumpTag(t))
    end
end

function Lib.rotVector2(x0, y0, angle)
    local d = math.acos(x0)
    d = d + angle
    local x1 = math.cos(d)
    local y1 = math.sin(d)
    return x1, y1
end

function Lib.Func(f, ...)
    local t = { ... }
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
function Lib.UnRegisterComponent(InstanceIDGameObject, InstanceIDComponent)
    for index, value in ipairs(Lib.ListComponent[InstanceIDGameObject]) do
        if value:GetInstanceID() == InstanceIDComponent then
            table.remove(Lib.ListComponent[InstanceIDGameObject], index)
            break
        end
    end
end

function Lib.CheckExistsComponent(InstanceIDGameObject, obj)
    if not Lib.ListComponent[InstanceIDGameObject] then
        return false
    end

    for index, value in ipairs(Lib.ListComponent[InstanceIDGameObject]) do
        if value == obj then
            return true
        end
    end

    return false
end

---@param InstanceIDGameObject number
---@param classname string
---@return Component
function Lib.GetComponent(InstanceIDGameObject, classname)
    for index, value in ipairs(Lib.ListComponent[InstanceIDGameObject]) do
        if (Lib.CheckTypeClass(classname, value)) then
            return value
        end
    end
    return APIGameObject.GetConponent(InstanceIDGameObject, classname)
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
    if Lib.ListClassName[classname] or _G[classname] then
        error("class " .. classname .. " đã tồn tại")
    else
        Lib.ListClassName[classname] = cls
    end
end

function Lib.GetClass(classname)
    if not Lib.ListClassName[classname] then
        error("Class " .. classname .. " không tồn tại")
    end
    return Lib.ListClassName[classname]
end

function Lib.GetOrAddGameObject(InstanceIDGameObject, tag)
    if not Lib.ListGameObject[InstanceIDGameObject] then
        local gameObject = GameObject.new(InstanceIDGameObject)
        gameObject.tag = tag
        gameObject.gameObject = gameObject
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
        transform.transform = transform
        Lib.ListTransform[InsTransform] = transform
    end
    return Lib.ListTransform[InsTransform]
end

function Lib.GetOrAddRectTransform(InsTransform, InstanceIDGameObject, tag)
    if not Lib.ListTransform[InsTransform] then
        local transform = RectTransform.new(InsTransform)
        transform.tag = tag
        transform:Init(InstanceIDGameObject);
        transform.gameObject.transform = transform
        transform.transform = transform
        Lib.ListTransform[InsTransform] = transform
    end
    return Lib.ListTransform[InsTransform]
end

function Lib.RemoveGameObject(InstanceIDGameObject)
    local gameObject = Lib.ListGameObject[InstanceIDGameObject]    
    if gameObject then
        if gameObject.transform then
            Lib.ListTransform[gameObject.transform:GetInstanceID()] = nil            
        end
        Lib.ListGameObject[InstanceIDGameObject] = nil        
    end
end

function Lib.CheckExistsGameObject(InstanceIDGameObject)
    if Lib.ListGameObject[InstanceIDGameObject] then
        return true
    end
    return false
end

function Lib.GetOrAddSprite(InsSprite)
    if not Lib.ListSprite[InsSprite] then
        local sprite = Sprite.new(InsSprite)
        Lib.ListSprite[InsSprite] = sprite
    end
    return Lib.ListSprite[InsSprite]
end

function Lib.GetOrAddAudioClip(InsAudioClip)
    if not Lib.ListAudioClip[InsAudioClip] then
        local audioClip = AudioClip.new(InsAudioClip)
        Lib.ListAudioClip[InsAudioClip] = audioClip
    end
    return Lib.ListAudioClip[InsAudioClip]
end

function Lib.SetObject(classname, InstanceID, InstanceIDGameObject, InsTransform, initparam, tag)
    local obj = Lib.GetClass(classname).new(InstanceID, InstanceIDGameObject);
    if type(tag) ~= "string" then
        assert(false, "Component không có tag " .. classname)
    end
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

function Lib.ExecuteFunction(obj, functionName, ...)
    if (type(obj[functionName]) == "function") then
        return obj[functionName](obj, ...)
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
function Lib.RealTimeCompiler(obj, classname)
    if Unity.IsEditor then
        local path = Lib.GetClass(classname).__path
        local oldClass = _G[classname]
        if path then
            Lib.ListClassName[classname] = nil
            _G[classname] = nil
            Unity.ReCompile(path)
        end
        local newObj = Lib.GetClass(classname)
        _G[classname] = oldClass
        for key, value in pairs(newObj) do
            if type(value) == "function" then
                obj[key] = value
                _G[classname][key] = value
            end
        end
        print("ReCompile success")
    end
end

function Lib.CheckGlobal(global)
    if _G[global] then
        assert(false, "Biến global " .. global .. " đã tồn tại")
    end
end

function Lib.SetScriptable(classname, params)
    if Unity.IsEditor then
        local path = Lib.GetClass(classname).__path
        if path then
            Lib.ListClassName[classname] = nil
            _G[classname] = nil
            Unity.ReCompile(path)
        end
    end
    local class = Lib.GetClass(classname).new()
    if params ~= nil then
        for key, value in pairs(params) do
            class[key] = value
        end
    end
    return class
end

function Lib.CreateColor(color)
    return Color.Copy(color)
end

function Lib.CreateVector2(vector2)
    return Vector2.Clone(vector2)
end

function Lib.CreateVector3(vector3)
    return Vector3.Copy(vector3)
end

function Lib.CreateQuaternion(quaternion)
    return Quaternion.Clone(quaternion)
end
