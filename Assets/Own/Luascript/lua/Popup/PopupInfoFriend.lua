---@class PopupInfoFriend : MonoBehaviour
---@field name TextMeshProGUI
---@field btnMakeFriend Button
local PopupInfoFriend = class("PopupInfoFriend", MonoBehaviour)
PopupInfoFriend.__path = __path

function PopupInfoFriend:OnBeginShow()
    local data = self.params.data
    self.send = nil
    self:Show(data)
    local friends = Me:GetFriend()
    local isHasFriend = false
    for key, value in pairs(friends) do
        local friend = value
        if friend.UUID == data.UUID then
            isHasFriend = true
        end
    end
    self.btnMakeFriend.gameObject:SetActive(not isHasFriend)
end

---@param data Friend
function PopupInfoFriend:Show(data)
    self.gameObject:SetActive(true)
    self.data = data
    self.name:SetText(data.name)
end

function PopupInfoFriend:Close()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self.gameObject:SetActive(false)
end

function PopupInfoFriend:AddFriend()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    if not self.send then
        FriendSocket:SendRequest(self.data.friendCode, function (resp)
            if resp.code == 1 then
                Toat:Show(resp.data.message, Constant.PoppupID.Popup_Toat)
                self.send = "Đã có yêu cầu kết bạn từ trước"
            elseif resp.code == 0 then
                Toat:Show(resp.error, Constant.PoppupID.Popup_Toat)
                self.send = resp.error
            end
        end)      
    else
        Toat:Show(self.send, Constant.PoppupID.Popup_Toat)
    end
end

function PopupInfoFriend:Visit()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    Event:Emit(Constant.Event.OnVisitFriend, self.data)
end

_G.PopupInfoFriend = PopupInfoFriend
