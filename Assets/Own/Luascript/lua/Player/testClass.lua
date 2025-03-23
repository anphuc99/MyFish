---@class testClass : MonoBehaviour
---@field num number
---@field str string
---@field table table
---@field obj GameObject
---@field trans Transform
---@field spriteRenderer SpriteRenderer
---@field s Sprite
local testClass = class("testClass", MonoBehaviour)
testClass.__path = __path
function testClass:Start()
    self.spriteRenderer:SetSprite(self.s)
end

function testClass:Update()    
     
end

return testClass
