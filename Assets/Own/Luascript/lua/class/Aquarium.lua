---@class Aquarium
local Aquarium = class("Aquarium")


function Aquarium:ctor(properties)
    self.UUID=properties.UUID
    self.properties=properties
    self.attributes={}
end


function Aquarium:update(any)
    for k, v in pairs(any) do
        self.properties[k] = v
    end
end

---@return any
function Aquarium:get()
    return self.properties
end
function Aquarium:setData(key,value)
    self.attributes[tostring(key)]=value
end

---@return any
function Aquarium:getData(key)
    return self.attributes[tostring(key)]
end


_G.Aquarium=Aquarium