---@class Component
---@field InstanceID: number
---@field Enable: string
Component = class("Component")

Component.listComponent = {}

function Component:ctor(InstanceID)    
    self.prototype = {
        _enable = true,
        _instanceID = InstanceID
    }
end

function Component:GetComponent(nameComponent)
    -- if Component[self.InstanceID] ~= nil and Component[self.InstanceID] then
    --     return Component[self.InstanceID][nameComponent]        
    -- end
end

function Component:GetInstanceID()
    return self.prototype._instanceID
end

-- function Component:GetEnable()
--     return self.prototype._enable
-- end

-- function Component:SetEnable(enable)
--     self.prototype._enable = enable

--     if enable then
--         if type(self.OnEnable) == "function" then
--             self:OnEnable()
--         end
--     else
--         if type(self.OnDisable) == "function" then
--             self:OnDisable()
--         end

--     end
-- end

---@param object Component
-- function Component:Destroy(object)
--     if type(object) ~= "table" then
--         return
--     end
--     if object.__cname == "GameObject" then
--         for key, value in pairs(Component.listComponent[object:GetInstanceID()]) do
--             for index, obj in ipairs(value) do
--                 if type(obj.OnDisable) == "function" then
--                     obj:OnDisable()
--                 end
        
--                 if type(obj.OnDestroy) == "function" then
--                     obj:OnDestroy()
--                 end
--             end
--         end
--         Component.listComponent[object:GetInstanceID()] = nil
--         Unity.DestroyGameObject(object:GetInstanceID())
--     else
--         if type(object.OnDisable) == "function" then
--             object:OnDisable()
--         end

--         if type(object.OnDestroy) == "function" then
--             object:OnDestroy()
--         end

--         for index, value in ipairs(Component.listComponent[object:GetInstanceID()][object.__cname]) do
--             if value == object then
--                 table.remove(Component.listComponent[object:GetInstanceID()][object.__cname], index)
--                 break
--             end
--         end
--     end
-- end