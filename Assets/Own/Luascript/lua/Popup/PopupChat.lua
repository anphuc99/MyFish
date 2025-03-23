---@class PopupChat : MonoBehaviour
---@field chatItemMe ChatItem
---@field chatItemOther ChatItem
---@field content Transform
---@field inputContent InputField
local PopupChat = class("PopupChat", MonoBehaviour)
PopupChat.__path = __path

function PopupChat:Awake()			
	self.evOnServerSendChat= Event:Register(Constant.Event.OnServerSendChat, Lib.handler(self, self.OnServerSendChat))
end

function PopupChat:OnDestroy()
	Event:UnRegister(Constant.Event.OnServerSendChat, self.evOnServerSendChat)
end

function PopupChat:OnServerSendChat(resp)
	self:AddItemChat(resp)
end

function PopupChat:AddItemChat(dataChat)
	local chatItem
	if dataChat.UUID == Me:get_player().UUID then
		---@type ChatItem
		chatItem = self:Instantiate(self.chatItemMe)
	else
		---@type ChatItem
		chatItem = self:Instantiate(self.chatItemOther)
	end
	chatItem.transform:SetParent(self.content)
	chatItem:SetName(dataChat.name)
	chatItem:SetContent(dataChat.content)
	chatItem:SetAvatar(dataChat.avatar)
end

function PopupChat:Submit()
	AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
	ChatSocket:SendChat(self.inputContent:GetText(), 1)
	self.inputContent:SetText("")
end

function PopupChat:close()
	AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
	PopupManager:hide(self.PopupID)
end

_G.Popup_test = PopupChat
