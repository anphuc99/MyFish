---@class DataLocalManager
DataLocalManager = {}

DataLocalManager.countSet = 0

function DataLocalManager:GetValue(key)
    if not DataLocalManager.data then
        DataLocalManager.data = {}
    end
    return DataLocalManager.data[key]
end

function DataLocalManager:SetValue(key, value)
    DataLocalManager.data[key] = value
    if self.timeSave ~= nil then
        self.timeSave = Time:startTimer(300, function ()
            self.timeSave = nil
            self:Save()
        end)
    end
    if self.countSet >= 10 then
        self:Save()
    else
        self.countSet = self.countSet + 1
    end
end

function DataLocalManager:Save()
    if self.timeSave ~= nil then
        Time:stopFramer(self.timeSave)
        self.timeSave = nil
    end
    self.countSet = 0
    APIDataLocalManager.Save()
end

---@param key string
function DataLocalManager:GetCache(key)
    return APIDataLocalManager.GetCache(key)
end

---@param key string
---@param value any
function DataLocalManager:SetCache(key, value)
    APIDataLocalManager.SetCache(key, value)
end