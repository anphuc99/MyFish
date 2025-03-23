---@class CreateUser : MonoBehaviour
local CreateUser = class("CreateUser", MonoBehaviour)
CreateUser.__path = __path

function CreateUser:Start()
    PopupManager:show(Constant.PoppupID.Popup_dialog, {
        texts = {
            ["1"] = "Oh! Người mới à?\nMình làm quen nha!",
            ["2"] = "Trước tiên hãy tạo cho mình một ao cá thật ấn tượng nào!"
        },
        onHide = function ()
            PopupManager:show(Constant.PoppupID.Popup_createUser)
        end
    })
end

_G.CreateUser = CreateUser
