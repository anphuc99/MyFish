---@class GameObject : Component
GameObject = class("GameObject", Component)

function GameObject:ctor()
    
end
---@param component string
---@param object Component
function GameObject:AddComponent(component, object)
    if type(object) ~= "table" then
        return
    end
    
    if Component.listComponent[self:GetInstanceID()] == nil then
        Component.listComponent[self:GetInstanceID()] = {}
    end
    if Component.listComponent[self:GetInstanceID()][component] == nil then
        Component.listComponent[self:GetInstanceID()][component] = {}
    end

    table.insert(Component.listComponent[self:GetInstanceID()][component], object)
    if type(object.Awake) == "function" then
        object:Awake()
    end

    if type(object.OnEnable) == "function" and object:GetEnable() then
        object:OnEnable()
    end
end