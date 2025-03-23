Lib.CheckGlobal("ProfileSocket")
ProfileSocket = {}

function ProfileSocket:SendGiftCode(code, callback)
    local data = {
        cmd = "giftcode",
        code = code
    }
    ServerHandler:SendMessage(Enum.Socket.PROFILE, data, callback)
end