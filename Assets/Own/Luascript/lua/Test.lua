---@class Test : Test2
---@field number number
---@field str string
---@field obj GameObject
---@field trans Transform
---@field image Image
---@field sprite Sprite
---@field btn Button
---@field taxt Text
---@field tmp TextMeshProGUI
---@field slider Slider
---@field scrollbar Scrollbar
---@field scriptable testScript
local Test = class("Test", Test2)
Test.__path = __path
function Test:Awake()
    self:TestLeanTweenMove()
    self:TestSocketIOOn()
    self:TestSocketIOSendMessage()
end

function Test:TestCoroutineWaitForSecond()    
    self.coroutine:start(Lib.handler(self, self.CoroutineWaitForSecond))
end

function Test:CoroutineWaitForSecond()
    print("start test")
    self.testCoroutine = false
    self.coroutine:WaitForSecond(2)
    print("end test")
    self.testCoroutine = true
end

function Test:TestCoroutineWaitForFrame()
    self.coroutine:start(Lib.handler(self, self.CoroutineWaitForFrame),1,2)
end

function Test:CoroutineWaitForFrame(a,b)
    print("start test",a,b)
    self.testCoroutine = false
    self.coroutine:WaitForEndOfFrame(40)
    print("end test",a,b)
    self.testCoroutine = true
end

function Test:TestCoroutineWaitUntil(a,b)
    self.coroutine:start(Lib.handler(self, self.CoroutineWaitUntil),3,4)
end

function Test:CoroutineWaitUntil(a,b)
    print("start test",a,b)
    self.testCoroutine = false    
    self.endTest = false
    Time:startTimer(2, function ()
        self.endTest = true
    end)
    self.coroutine:WaitUntil(function ()
        return self.endTest
    end)
    print("end test",a,b)
    self.testCoroutine = true
end

function Test:TestCoroutineWaitCo()    
    self.coroutine:start(Lib.handler(self, self.CoroutineWaitCo))
end

function Test:Co1()
    print("start test co 1")
    self.coroutine:WaitForSecond(1)
    print("end test co 1")
end

function Test:Co2()
    print("start test co 2")
    self.coroutine:WaitForSecond(1)
    print("end test co 2")
end

function Test:CoroutineWaitCo()    
    print("Start test")
    self.coroutine:WaitCoroutine(Lib.handler(self, self.Co1))
    self.coroutine:WaitCoroutine(Lib.handler(self, self.Co2))
    self.testCoroutine = true
    print("End test")
end

function Test:TestStopCorotine()
    local id = self:TestCoroutineWaitForSecond()
    self.coroutine:start()
end

function Test:TestLeanTweenMove()
    LeanTween:move(self.gameObject, Vector3.new(1,10,0), 10)
end

function Test:TestSocketIOOn()
    ServerHandler:On("chat", function (res)
        print("chat")
        Lib.pv(res)
    end)
end

function Test:TestSocketIOSendMessage()
    ServerHandler:SendMessage("send", {message = "Hello nha"}, function (res)
        print("call back")
        Lib.pv(res)
    end)
end

function Test:TestComponent(func,...)    
    return self[func](self,...)
end

function Test:TestGameObject(func,...)
    return self.gameObject[func](self,...)
end

function Test:TestTransform(func,...)
    return self.transform[func](self,...)
end

function Test:TestObj(func,...)
    return self.obj[func](self,...)
end

function Test:TestTrans(func,...)
    return self.trans[func](self,...)
end

function Test:TestImage(func,...)
    return self.image[func](self,...)
end

function Test:TestSprite(func,...)
    return self.slider[func](self,...)
end

function Test:TestBtn(func,...)
    return self.btn[func](self,...)
end

function Test:TestTxt(func,...)
    return self.txt[func](self,...)
end

function Test:TestTmp(func,...)
    return self.tmp[func](self,...)
end

function Test:TestSlider(func,...)
    return self.slider[func](self,...)
end

function Test:TestScrollbar(func,...)
    return self.scrollbar[func](self,...)
end

return Test
