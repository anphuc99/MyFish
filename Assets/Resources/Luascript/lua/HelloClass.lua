
---@class HelloClass : MonoBehaviour
---@field id number
---@field gameObject string
---@field aaa Hi
local HelloClass = class("HelloClass", MonoBehaviour)

function HelloClass:Awake()
    print(self.aaa.kkk)
end

function HelloClass:Start()
    print("HelloClass Start")
end

function HelloClass:Update()
    print("hahahahah")
end



return HelloClass


