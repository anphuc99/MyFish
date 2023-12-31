---@class Button : Component
local Button, base = class("Button", Component)

function Button:ctor(InstanceID)
    base.ctor(self, InstanceID)
    self.onClick = {}
    self.mamama = "Gameobject destroy pass"
end

function Button:OnInit()
    UnityEvent.RegiterEvent(self:GetInstanceID(), "ButtonOnClick", self.Invoke)
    UnityEvent.RegiterEvent(self.gameObject:GetInstanceID(), "GameObjectDestroy", Lib.handler(self, self.OnDestroy))
end

function Button:onClickAddListener(func, obj)
    self.onClick[func] = obj or true
end

function Button:onClickRemoveListener(func)
    self.onClick[func] = nil
end

function Button:Invoke()
    if self.onClick then
        for func, value in pairs(self.onClick) do
            func(value)
        end        
    end
end

function Button:OnDestroy()    
    self.onClick = nil
end

rawset(_G, "Button", Button)