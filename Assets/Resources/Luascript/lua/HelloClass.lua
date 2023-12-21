
---@class HelloClass: MonoBehaviour
---@field id number
---@field gameObject string
---@field aaa Hi
local HelloClass = class("HelloClass", MonoBehaviour)

function HelloClass:Awake()

end

function HelloClass:Start()
    print("HelloClass Start")    
    -- self.transform:Move(Vector3.up + Vector3.new(1,2,3))    
    local quaternion = Quaternion.Euler(0,0,30)
    
    self.transform:SetRotation(quaternion)
end

function HelloClass:Update()
    local pos = self.transform:GetPosition()
    print("hahahahah", pos.x, pos.y, pos.z)
end



return HelloClass


