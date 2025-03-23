---@class Test2 : MonoBehaviour
---@field txt TextMeshProGUI
local Test2 = class("Test2", MonoBehaviour)
Test2.__path = __path

function Test2:Click()
    PopupManager:show(Constant.PoppupID.Popup_Reward, {
        ["1"] = {
            UID = 100001,
            amount = 100,
            name = "Vàng"
        },
        ["2"] = {
            UID = 100002,
            amount = 100,
            name = "Kim cương"
        },
        ["3"] = {
            UID = 14110001,
            amount = 10,
            name = "ddd"
        }
    })
end

_G.Test2 = Test2
