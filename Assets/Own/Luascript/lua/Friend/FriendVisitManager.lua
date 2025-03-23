---@class FriendVisitManager : MonoBehaviour
local FriendVisitManager = class("FriendVisitManager", MonoBehaviour)
FriendVisitManager.__path = __path
function FriendVisitManager:Awake()
    self.evOnVisitFriend = Event:Register(Constant.Event.OnVisitFriend, Lib.handler(self, self.OnVisitFriend))
    self.evOutFriendZone = Event:Register(Constant.Event.OnOutFriendZone, Lib.handler(self, self.OnOutFriendZone))
end

function FriendVisitManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnVisitFriend, self.evOnVisitFriend)
    Event:UnRegister(Constant.Event.OnOutFriendZone, self.evOutFriendZone)
end

function FriendVisitManager:OnVisitFriend(friend)
    local UUID = friend.UUID
    local status = friend.status
    if status == Constant.FriendStatus.Online then
        self:CanNotVisitFriend()
        return
    end
    Global.BackupMe = Me 
    Me = clone(Me)
    Me.other = Global.BackupMe
    PlayerSocket:getPlayer(function(data)
        if data.code == 1 then
            local inform = data.data
            Me:InitPlayer(inform)
            Me.data.aquarium = {}
            self:GetAquarium(UUID)
        end
    end, UUID)
end

function FriendVisitManager:CanNotVisitFriend()
    PopupManager:show(Constant.PoppupID.Popup_Notification, {
        title = "THÔNG BÁO",
        desrciption = "Chủ nhà đang ở đó, không thể vào hồ",
        btnYes = {
            text = "Đồng Ý",
            onClick = function()
                AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                PopupManager:hide(Constant.PoppupID.Popup_Notification)                
            end
        },
        btnNo = {
            disable = true
        }
    })
end

function FriendVisitManager:OnOutFriendZone()
    Me:get_player():Remove()
    Me = Global.BackupMe
    PopupManager:HideAllPopup()
    SceneLoader:Load(Constant.Scene.GamePlay)
end

function FriendVisitManager:GetAquarium(UUID)
    AquariumSocket:GetAquarium(function (resp)
        if resp.code == 1 then
            self:LoadScene()
        end
    end, UUID)                
end

function FriendVisitManager:LoadScene()
    Time:startFramer(1, function ()
        if Me:get_aquarium()[1] then
            PopupManager:HideAllPopup()
            SceneLoader:Load(Constant.Scene.FriendZone)
            return false
        end
        return true
    end)
end

_G.FriendVisitManager = FriendVisitManager
