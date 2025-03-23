---@class Mail
local Mail = class("Mail")


function Mail:ctor(properties)
    self.UUID=properties.UUID
    self.properties=properties
    self.attributes={}
end


function Mail:update(any)
    for k, v in pairs(any) do
        self.properties[k] = v
    end
end

---@return any
function Mail:get()
    return self.properties
end
function Mail:setData(key,value)
    self.attributes[tostring(key)]=value
end

---@return any
function Mail:getData(key)
    return self.attributes[tostring(key)]
end


_G.Mail=Mail