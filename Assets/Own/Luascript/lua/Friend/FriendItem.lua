---@class FriendItem : MonoBehaviour
---@field txtName TextMeshProGUI
---@field txtLevel TextMeshProGUI
---@field imgGender Image
---@field imgAvatar Image
---@field sprMale Sprite
---@field sprFemale Sprite
---@field imgOnline Image
local FriendItem = class("FriendItem", MonoBehaviour)
FriendItem.__path = __path

function FriendItem:OnDestroy()
    if self.friendData then
        Event:UnRegister(Constant.Event.PLAYER_ONLINE..self.friendData.UUID, self.evPlayerOnlien)
    end
end


---@param friendData Friend
function FriendItem:SetFriend(friendData)
    self.evPlayerOnlien = Event:Register(Constant.Event.PLAYER_ONLINE..friendData.UUID, function (resp)
        Lib.pv(resp)
        self:SetOnline(resp.status)        
    end)
    self.friendData = friendData
    self.txtLevel:SetText(friendData.level)
    self.txtName:SetText(friendData.name)
    if friendData.gender == Constant.Gender.Male then
        self.imgGender:SetSprite(self.sprMale)
    else
        self.imgGender:SetSprite(self.sprFemale)
    end
    self:setAvatar(friendData.avatar)
    self:SetOnline(friendData.status)
end

function FriendItem:setAvatar(avatarLink)
    Sprite:CreateSpriteFromURL(avatarLink, function (spr)
        self.imgAvatar:SetSprite(spr)
    end)
end

function FriendItem:OnClick()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    self:ShowInfomation()
end

function FriendItem:ShowInfomation()
    self.parent:ShowInfomation(self.friendData)
end

function FriendItem:SetOnline(online)
    self.imgOnline.gameObject:SetActive(online == Constant.FriendStatus.Online)
end

_G.FriendItem = FriendItem