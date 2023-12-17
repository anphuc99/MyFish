
---@class Hi : MonoBehaviour
---@field kkk  string
local Hi = class("Hi", MonoBehaviour)

function Hi:Awake()    
    print("kkkkkkkkkkkkkk")        
end

function Hi:Start()
    print("Hi start")
end

return Hi