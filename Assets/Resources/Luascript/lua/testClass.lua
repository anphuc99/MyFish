---@class testClass : MonoBehaviour
---@field num number
---@field str string
---@field table table
---@field obj GameObject
---@field trans Transform
local testClass = class("testClass", MonoBehaviour)
testClass.__path = "lua/testClass.lua"
function testClass:Start()
    print("Co path không ", self.__path, self.tag, self.trans.tag, self.obj.tag, self.trans.gameObject.tag, self.obj.transform.tag)
    self.trans.gameObject:SetActive(false)
    self.gameObject:AddComponent("Test2")
end

function testClass:Update()
    print(self.num) 
    print("sao saodđ22eewwwee2www")        
end

return testClass
