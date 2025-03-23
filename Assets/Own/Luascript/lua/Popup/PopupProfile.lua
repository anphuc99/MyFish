---@class PopupProfile : MonoBehaviour
---@field avatar Image
---@field name TextMeshProGUI
---@field input TMP_InputField
---@field friendLogManager FriendLogManager
local PopupProfile = class("PopupProfile", MonoBehaviour)
PopupProfile.__path = __path

function PopupProfile:OnBeginShow()
    self.evAvatar = Event:Register(Constant.Event.Avatar, Lib.handler(self, self.UpdateAvatar))    
    self:Refresh()
    self.friendLogManager:LoadFriendLog()
end

function PopupProfile:OnEndHide()
    Event:UnRegister(Constant.Event.Avatar, self.evAvatar)
end

function PopupProfile:ChangeAvatar()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    File:OpenPanel(function (paths)
        local base64 = self:LoadImage(paths[1])
        self:SendImage(base64)
    end, "",{
        filterName = "Image Files",
        filterExtensions = {"png", "jpg", "jpeg"}
    })
end

function PopupProfile:LoadImage(path)
    return File:ReadAllBytes(path)        
end

function PopupProfile:SendImage(base64)
    ServerHandler:SendHTTP("/user/upload", {
        image = "data:image/png;base64,"..base64
    }, Lib.handler(self, self.UpImageSuccess), Lib.handler(self, self.UpImageFail))
end

function PopupProfile:UpImageSuccess(resp)
    print("Up Image Success")
end

function PopupProfile:UpImageFail(resp)
    error("Up Image Fail")
end

function PopupProfile:Refresh()
    self:UpdateAvatar()
    self:UpdateName()
end

function PopupProfile:UpdateAvatar()
    local player = Me:get_player()
    player:GetSpriteAvatar(function (spr)
        self.avatar:SetSprite(spr)
    end)
end

function PopupProfile:UpdateName()
    local player = Me:get_player()
    self.name:SetText(player:get().name)
end

function PopupProfile:SendGiftCode()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    local gificode = self.input:GetText()
    ProfileSocket:SendGiftCode(gificode, function (resp)
        if resp.code == 1 then
            self.input:SetText("")
            PopupManager:show(Constant.PoppupID.Popup_Reward, {
                ["1"] = {
                    UID = "gift",
                    amount = 1,
                    name = "Phần quà!",
                    description = "Vui lòng kiểm tra thư để nhận quà!"
                }   
            })
        else
            PopupManager:show(Constant.PoppupID.Popup_Notification, {
                title = "THÔNG BÁO",
                    desrciption = resp.error,
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
    end)
end

function PopupProfile:Close()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(self.PopupID)
end


_G.PopupProfile = PopupProfile
