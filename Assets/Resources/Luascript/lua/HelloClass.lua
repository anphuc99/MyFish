
---@class HelloClass: MonoBehaviour
---@field id number
---@field gameObject string
---@field aaa Hi
local HelloClass = class("HelloClass", MonoBehaviour)

function HelloClass:Awake()

end

function HelloClass:Start()
    print("HelloClass Start")
    self.aaa = self:GetComponent("Hi")
    print(self.aaa.kkk)
    self:Destroy(self.aaa)
end

function HelloClass:Update()
    print("hahahahah")
end



return HelloClass


