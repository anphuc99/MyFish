require("class")

---@class Transform : Component
local Transform, base = class("Transform", Component)
setmetatable(Transform, Transform)


function Transform:OnInit()
    print("chao nha")
end

function Transform:Move()
    
end

function Transform:Rotate()
    
end

function Transform:SmoothRotate()
    
end

function Transform:__index(key)
    return rawget(self, key)
end

rawset(_G, "Transform", Transform)