---@class MoveToTarget : MonoBehaviour
local MoveToTarget = class("MoveToTarget", MonoBehaviour)
MoveToTarget.__path = __path

function MoveToTarget:Awake()
    self.target = nil
    self.object = nil
end

---@param target Vector3
---@param object GameObject
---@param speed number
---@param callback function
function MoveToTarget:SetTarget(target, object, speed ,callback)
    self.targetObject = nil
    self.target = target
    self.object = object
    self.speed = speed
    self.callback = callback
end

---@param targetObject GameObject
---@param object GameObject
---@param speed number
---@param callback function
function MoveToTarget:SetTargetObject(targetObject, object, speed , callback)
    self.target = nil
    self.targetObject = targetObject
    self.object = object
    self.speed = speed
    self.callback = callback
end

function MoveToTarget:Stop()
    self.target = nil
    self.targetObject = nil
    if self.object then
        self.object.transform:StopMove()
    end
end

function MoveToTarget:Update()
    self:Flip()
    self:Move()
end

function MoveToTarget:Flip()
    if self.targetObject == nil or self.targetObject:IsDestroy() then
        return
    end
    local target
    if self.target then
        target = self.target
    elseif self.targetObject then        
        target = self.targetObject.transform:GetPosition()
    end
    if target then
        local localScale = self.object.transform:GetLocalScale()
        local object = self.object.transform:GetPosition()
        if object.x > target.x then
            localScale.x = -math.abs(localScale.x)
        elseif object.x < target.x then
            localScale.x = math.abs(localScale.x)
        end        
        self.object.transform:SetLocalScale(localScale)
    end
end

function MoveToTarget:Move()    
    if self.target then
        local v3 = self.object.transform:GetPosition()
        local Dic = self.target - v3
        self.object.transform:Move(Dic:Normalize() * self.speed)
        if Vector3.Distance(v3, self.target) <= 0.5 then
            self:Stop()
            self.target = nil
            self.callback()
        end
    elseif self.targetObject then    
        if self.targetObject:IsDestroy() then            
            self.targetObject = nil
            self.callback(false)
            return
        end                
        local target = self.targetObject.transform:GetPosition()
        local object = self.object.transform:GetPosition()
        local v3 = target - object
        if Vector3.Distance(target, object) <= 0.5 then            
            self:Stop()
            self.targetObject = nil
            self.callback(true)
        else
            self.object.transform:Move(v3:Normalize() * self.speed)
        end
    end
end

function MoveToTarget:Rot()
    
end

_G.MoveToTarget = MoveToTarget
