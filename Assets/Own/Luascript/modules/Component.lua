---@class Component
---@field gameObject GameObject
---@field transform Transform
---@field InstanceID number
---@field Enable string
---@field tag string
Component = class("Component")

function Component:ctor(InstanceID)        
    self.prototype = {
        _enable = true,
        _instanceID = InstanceID
    }
end

function Component:Init(InstanceIDgameObject)
    self.gameObject = Lib.GetOrAddGameObject(InstanceIDgameObject, self.tag)    
    Lib.RegisterComponent(self.gameObject:GetInstanceID(), self)
    self:OnInit()
end

function Component:OnInit()        
end

function Component:GetComponent(classname)
    return Lib.GetComponent(self.gameObject:GetInstanceID(), classname)
end

function Component:GetInstanceID()
    return self.prototype._instanceID
end

function Component:GetEnable()
    return self.prototype._enable
end

function Component:SetEnable(enable)
    self.prototype._enable = enable    
    APIGameObject.Enable(self.gameObject:GetInstanceID(), self:GetInstanceID(), enable)    
end

function Component:IsDestroy()
    return not Lib.CheckExistsComponent(self:GetInstanceID(), self)
end

function Component:Destroy(object)
    if type(object) ~= "table" then
        return
    end

    if object.__cname == "GameObject" then   
        APIGameObject.Destroy(object:GetInstanceID())        
    elseif Lib.CheckTypeClass("MonoBehaviour", object) then
        APIGameObject.DestroyComponent(object.gameObject:GetInstanceID(), object:GetInstanceID())        
    elseif Lib.CheckTypeClass("Component", object) then
        if object.OnDestroy then
            object:OnDestroy()
        end        
        APIGameObject.DestroyComponent(object.gameObject:GetInstanceID(), object:GetInstanceID())        
    end
end

---@return any
function Component:Instantiate(object)
    if type(object) ~= "table" then
        return
    end
    ---@type GameObject
    local gameObject
    if object.__cname == "GameObject" then
        gameObject = object
        local obj = APIGameObject.Instantiate(gameObject:GetInstanceID())
        -- print(obj)
        return obj
    elseif object.__cname == "Transform" then
        gameObject = object.gameObject
        local obj = APIGameObject.Instantiate(gameObject:GetInstanceID())
        return obj.transform
    elseif Lib.CheckTypeClass("Component", object) then
        gameObject = object.gameObject
        local obj = APIGameObject.Instantiate(gameObject:GetInstanceID())
        local cpm = obj:GetComponent(object.__cname)
        return cpm
    end

end

---@param parent Transform
---@return any
function Component:InstantiateWithParent(object, parent)
    if type(object) ~= "table" then
        return
    end
    ---@type GameObject
    local gameObject
    if object.__cname == "GameObject" then
        gameObject = object
        local obj = APIGameObject.InstantiateWithParent(gameObject:GetInstanceID(), parent:GetInstanceID())
        return obj
    elseif object.__cname == "Transform" then
        gameObject = object.gameObject
        local obj = APIGameObject.InstantiateWithParent(gameObject:GetInstanceID(), parent:GetInstanceID())
        return obj.transform
    elseif Lib.CheckTypeClass("Component", object) then
        gameObject = object.gameObject
        local obj = APIGameObject.InstantiateWithParent(gameObject:GetInstanceID(), parent:GetInstanceID())
        local cpm = obj:GetComponent(object.__cname)
        return cpm
    end
end
---@param object any
---@param vector3 Vector3
---@param quaternion Quaternion
---@return any
function Component:InstantiateWithPosition(object, vector3, quaternion)
    if type(object) ~= "table" then
        return
    end
    ---@type GameObject
    local gameObject
    if object.__cname == "GameObject" then
        gameObject = object
        local obj = APIGameObject.InstantiateWithPosition(gameObject:GetInstanceID(), vector3:toTable(), quaternion:toTable())
        return obj
    elseif object.__cname == "Transform" then
        gameObject = object.gameObject
        local obj = APIGameObject.InstantiateWithPosition(gameObject:GetInstanceID(), vector3:toTable(), quaternion:toTable())
        return obj.transform
    elseif Lib.CheckTypeClass("Component", object) then
        gameObject = object.gameObject
        local obj = APIGameObject.InstantiateWithPosition(gameObject:GetInstanceID(), vector3:toTable(), quaternion:toTable())
        local cpm = obj:GetComponent(object.__cname)
        return cpm
    end

end