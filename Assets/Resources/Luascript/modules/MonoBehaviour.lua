---@class MonoBehaviour : Component
---@field Awake function
---@field Start function
---@field OnEnable function
---@field OnDisable function
---@field OnDestroy function
---@field Update function
---@field OnMouseDown function
---@field OnMouseUp function
---@field OnMouseEnter function
---@field OnMouseExit function
local MonoBehaviour,base = class("MonoBehaviour", Component)


function MonoBehaviour:OnInit()       
    base.OnInit(self)  
    -- self.coroutine = Coroutine.new()   
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
    
    if type(self.OnMouseDown) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnMouseDown", self.OnMouseDown)
    end    

    if type(self.OnMouseUp) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnMouseUp", self.OnMouseUp)
    end    

    if type(self.OnMouseEnter) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnMouseEnter", self.OnMouseEnter)
    end    

    if type(self.OnMouseExit) == "function" then
        UnityEvent.RegiterEvent(self:GetInstanceID(), "OnMouseExit", self.OnMouseExit)
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

function MonoBehaviour:UniInit()
    if type(self.Awake) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "Awake", self.Awake)        
    end
    
    if type(self.Start) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "Start", self.Start)
    end
    
    if type(self.OnEnable) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnEnable", self.OnEnable)
    end
    
    if type(self.OnDisable) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnDisable", self.OnDisable)
    end    
    
    if type(self.OnDestroy) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnDestroy", self.OnDestroy)
    end    
    
    if type(self.OnMouseDown) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnMouseDown", self.OnMouseDown)
    end    

    if type(self.OnMouseUp) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnMouseUp", self.OnMouseUp)
    end    

    if type(self.OnMouseEnter) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnMouseEnter", self.OnMouseEnter)
    end    

    if type(self.OnMouseExit) == "function" then
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnMouseExit", self.OnMouseExit)
    end    
    
    if type(self.Update) == "function" then            
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnEnable", self.EnableUpdate)
        UnityEvent.UnRegiterEvent(self:GetInstanceID(), "OnDisable", self.DisableUpdate)
        Time:unUpdate(self.Update)
    end

end

rawset(_G, "MonoBehaviour", MonoBehaviour)