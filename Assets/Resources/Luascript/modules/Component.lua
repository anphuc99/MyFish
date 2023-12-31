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
    Unity.SetEnableComponent(self.gameObject:GetInstanceID(), self:GetInstanceID(), enable)    
end


function Component:Destroy(object)
    if type(object) ~= "table" then
        return
    end

    if object.__cname == "GameObject" then
        Lib.RemoveGameObject(object:GetInstanceID())
        Unity.DestroyObject(object:GetInstanceID())
    elseif Lib.CheckTypeClass("MonoBehaviour", object) then
        Unity.DestroyComponent(object.gameObject:GetInstanceID(), object:GetInstanceID())
    elseif Lib.CheckTypeClass("Component", object) then
        if object.OnDestroy then
            object:OnDestroy()
        end        
        Unity.DestroyComponent(object.gameObject:GetInstanceID(), object:GetInstanceID())

    end
end


function Component:Instantiate(component)
    if type(component) ~= "table" then
        return
    end
    ---@type GameObject
    local gameObject
    if component.__cname == "GameObject" then
        gameObject = component
        local object = Unity.InstantiateLuaObject(gameObject:GetInstanceID())
        return object
    elseif Lib.CheckTypeClass("Component", component) then
        gameObject = component.gameObject
        local object = Unity.InstantiateLuaObject(gameObject:GetInstanceID())
        local cpm = object:GetComponent(component.__cname)
        return cpm
    end

end