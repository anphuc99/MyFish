---@class LookingFriend : MonoBehaviour
---@field friendItem FriendItem
---@field content Transform
---@field search TMP_InputField
local LookingFriend = class("LookingFriend", MonoBehaviour)
LookingFriend.__path = __path

function LookingFriend:OnSearch()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    if not self.delay then
        self:Looking()
        self.delay = true
        Time:startTimer(2, function ()
            self.delay = false
        end)
    else
        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = "Sống vội thế bạn?",
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
end

function LookingFriend:Looking()
    self:RemoveItem()
    if self.search:GetText() ~= "" then
        local friendCode = tonumber(self.search:GetText())
        local me = Me:get_player():get()
        if me.friend_code == friendCode then
            PopupManager:show(Constant.PoppupID.Popup_Notification, {
                title = "THÔNG BÁO",
                desrciption = "Bạn bị tự kỷ hả?",
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
            return
        end
        FriendSocket:LookingFriend(friendCode, function (resp)
            if resp.code == 1 then
                Lib.pv(resp)
                local list = resp.data.list
                for key, value in pairs(list) do
                    ---@type FriendItem
                    local friendItem = self:InstantiateWithParent(self.friendItem, self.content)
                    friendItem:SetFriend(Friend.new(value))
                    friendItem.parent = self
                    self.search:SetText("")
                end
            end
        end)        
    end
end

function LookingFriend:RemoveItem()
    local allChild = self.content:GetAllChild()
    for key, value in pairs(allChild) do
        self:Destroy(value.gameObject)
    end
end

function LookingFriend:ShowInfomation(data)
    PopupManager:show(Constant.PoppupID.Popup_InfoFriend, {data = data})
end

_G.LookingFriend = LookingFriend
