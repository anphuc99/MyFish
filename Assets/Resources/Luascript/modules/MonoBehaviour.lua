---@class MonoBehaviour : Component
---@field Awake function
---@field Start function
---@field OnEnable function
---@field OnDisable function
---@field OnDestroy function
---@field Update function
MonoBehaviour = class("MonoBehaviour", Component)

function MonoBehaviour:ctor(InstanceID)
    self.super:ctor(InstanceID)
    if type(self.Awake) == "function" then
        UnityEvent.RegiterEvent(InstanceID, "Awake", self.Awake)        
    end

    if type(self.Start) == "function" then
        UnityEvent.RegiterEvent(InstanceID, "Start", self.Start)
    end

    if type(self.OnEnable) == "function" then
        UnityEvent.RegiterEvent(InstanceID, "OnEnable", self.OnEnable)
    end

    if type(self.OnDisable) == "function" then
        UnityEvent.RegiterEvent(InstanceID, "OnDisable", self.OnDisable)
    end    

    if type(self.OnDestroy) == "function" then
        UnityEvent.RegiterEvent(InstanceID, "OnDestroy", self.OnDestroy)
    end    

    if type(self.Update) == "function" then        
        UnityEvent.RegiterEvent(InstanceID, "OnEnable", self.EnableUpdate)
        UnityEvent.RegiterEvent(InstanceID, "OnDisable", self.DisableUpdate)
    end
end

function MonoBehaviour:EnableUpdate()    
    Time:update(self.Update, self)
end

function MonoBehaviour:DisableUpdate()
    Time:unUpdate(self.Update)
end