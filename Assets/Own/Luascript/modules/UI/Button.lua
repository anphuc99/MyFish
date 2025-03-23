---@class Button : Component
local Button, base = class("Button", Component)

local btnID = 0

function Button:ctor(InstanceID)
    base.ctor(self, InstanceID)
    self.onClick = {}
end

function Button:OnInit()
    UnityEvent.RegiterEvent(self:GetInstanceID(), "ButtonOnClick", self.Invoke)
    UnityEvent.RegiterEvent(self.gameObject:GetInstanceID(), "GameObjectDestroy", Lib.handler(self, self.OnDestroy))
end

function Button:onClickAddListener(func)
    local id = btnID
    self.onClick[id] = func
    btnID = btnID + 1
    return id
end

function Button:onClickRemoveListener(id)
    self.onClick[id] = nil
end

function Button:onClickRemoveAll()
    self.onClick = {}
end

function Button:Invoke()
    if self.onClick then
        for id, func in pairs(self.onClick) do
            func()
        end        
    end
end

function Button:OnDestroy()    
    self.onClick = nil
end

function Button:SetInteractable(interactable)
    APIButton.SetInteractable(interactable, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function Button:GetInteractable()
    return APIButton.GetInteractable(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

_G.Button = Button