---@class MonoBehaviour : Component
---@field Awake function
---@field Start function
---@field OnEnable function
---@field OnDisable function
---@field OnDestroy function
---@field Update function
local MonoBehaviour,base = class("MonoBehaviour", Component)


function MonoBehaviour:OnInit()       
    base.OnInit(self)     
    if type(self.Awake) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "Awake", self.Awake)        
    end
    
    if type(self.Start) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "Start", self.Start)
    end
    
    if type(self.OnEnable) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnEnable", self.OnEnable)
    end
    
    if type(self.OnDisable) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnDisable", self.OnDisable)
    end    
    
    if type(self.OnDestroy) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnDestroy", self.OnDestroy)
    end    
    
    if type(self.Update) == "function" then            
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnEnable", self.EnableUpdate)
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnDisable", self.DisableUpdate)
    end
end

function MonoBehaviour:EnableUpdate()        
    Time:update(self.Update, self)
end

function MonoBehaviour:DisableUpdate()
    Time:unUpdate(self.Update)
end

rawset(_G, "MonoBehaviour", MonoBehaviour)