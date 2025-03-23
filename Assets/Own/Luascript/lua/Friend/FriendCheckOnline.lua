---@class FriendCheckOnline : MonoBehaviour
local FriendCheckOnline = class("FriendCheckOnline", MonoBehaviour)
FriendCheckOnline.__path = __path

function FriendCheckOnline:Awake()
    print("sssssssssssssssss")
    self.evPlayerOnlien = Event:Register(Constant.Event.PLAYER_ONLINE..Me:get_player().UUID, function (resp)
        self:NoticationNewFriend()
    end)
    FriendSocket:LookingFriend(Me:get_player():get().friend_code, function (resp)
        local status = resp.data.list[1].status
        if status == Constant.FriendStatus.Online then
            self:NoticationNewFriend()
        end
    end)
end

function FriendCheckOnline:OnDestroy()
    Event:UnRegister(Constant.Event.PLAYER_ONLINE..Me:get_player().UUID, self.evPlayerOnlien)
end

function FriendCheckOnline:NoticationNewFriend()
    PopupManager:show(Constant.PoppupID.Popup_Notification, {
        title = "THÔNG BÁO",
        desrciption = "Chủ nhà đã về, mau chuồn thôi!",
        btnYes = {
            text = "Đồng Ý",
            onClick = function()
                AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                PopupManager:hide(Constant.PoppupID.Popup_Notification)
                self:OutFriendZone()
            end
        },
        btnNo = {
            disable = true
        }
    })
end

function FriendCheckOnline:OutFriendZone()
    Event:Emit(Constant.Event.OnOutFriendZone)
end

_G.FriendCheckOnline = FriendCheckOnline
