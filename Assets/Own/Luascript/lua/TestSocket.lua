---@class TestSocket : MonoBehaviour
local TestSocket = class("TestSocket", MonoBehaviour)
TestSocket.__path = __path

function TestSocket:test()
    FriendSocket:GetListFriend(function (resp)
        Lib.pv(resp)
    end)
end
_G.TestSocket = TestSocket
