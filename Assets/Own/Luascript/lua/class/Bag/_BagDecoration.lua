---@class _BagDecoration
local _BagDecoration = class("_BagDecoration")

function _BagDecoration:ctor(properties)
    self.UID=properties.UID
    self.properties=properties
    self.attributes={}
end

function _BagDecoration:update(any)
    for k, v in pairs(any) do
        self.properties[k] = v
    end
end

---@return any
function _BagDecoration:get()
    return self.properties
end

function _BagDecoration:setData(key,value)
    self.attributes[tostring(key)]=value
end

---@return any
function _BagDecoration:getData(key)
    return self.attributes[tostring(key)]
end

_G._BagDecoration=_BagDecoration