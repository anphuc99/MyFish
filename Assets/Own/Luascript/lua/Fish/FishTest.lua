
---@class FishTest : MonoBehaviour
local FishTest = class("FishTest", MonoBehaviour)
FishTest.__path = __path
-- function FishTest:Start()
--     local query = {
--         cmd = "get"
--     }
--     ServerHandler:SendMesseage("fish_shop", query, function (data)
--         Lib.pv(data)
--     end)
-- end

function FishTest:Update()
    
end

_G.FishTest = FishTest
