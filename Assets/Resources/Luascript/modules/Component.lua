---@class Component
---@field gameObject GameObject
---@field transform Transform
---@field InstanceID number
---@field Enable string
Component = class("Component")

function Component:ctor(InstanceID)        
    self.prototype = {
        _enable = true,
        _instanceID = InstanceID
    }
end

function Component:Init(InstanceIDgameObject)
    print(InstanceIDgameObject, self.__cname)
    self.gameObject = Lib.GetOrAddGameObject(InstanceIDgameObject)    
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
        Unity.DestroyObject(object:GetInstanceID())
    elseif Lib.CheckTypeClass("Component", object) then
        Unity.DestroyComponent(object.gameObject:GetInstanceID(), object:GetInstanceID())
    end
end