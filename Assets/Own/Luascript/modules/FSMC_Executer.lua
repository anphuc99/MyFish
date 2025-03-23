---@class FSMC_Executer : Component
---@field params table
FSMC_Executer = class("FSMC_Executer", Component)

function FSMC_Executer:GetName()
    return APIFSMC_Executer.GetName(self.gameObject:GetInstanceID(),self:GetInstanceID())
end 

function FSMC_Executer:SetFloat(name, value)
    APIFSMC_Executer.SetFloat(name, value, self.gameObject:GetInstanceID(),self:GetInstanceID())
end

function FSMC_Executer:GetFloat(name)
    return APIFSMC_Executer.GetFloat(name, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function FSMC_Executer:SetInt(name, value)
    APIFSMC_Executer.SetInt(name, value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function FSMC_Executer:GetInt(name)
    return APIFSMC_Executer.GetInt(name, self.gameObject:GetInstanceID(), self:GetInstanceID())    
end

function FSMC_Executer:SetBool(name, value)
    APIFSMC_Executer.SetBool(name, value, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function FSMC_Executer:GetBool(name)
    return APIFSMC_Executer.GetBool(name, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function FSMC_Executer:SetTrigger(name)
    APIFSMC_Executer.SetTrigger(name, self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function FSMC_Executer:SetCurrentState(name)
    APIFSMC_Executer.SetCurrentState(name, self.gameObject:GetInstanceID(), self:GetInstanceID())
end