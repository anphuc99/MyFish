---@class PopupMail : MonoBehaviour
---@field exit Button
---@field email GameObject
---@field email_container Transform
local PopupMail = class("PopupMail", MonoBehaviour)
PopupMail.__path = __path

function PopupMail:Awake()
  PopupMail.Instance = self
  self.mail_list={}
  self.eventID1= Event:Register(Constant.Event.ReceiveMail, function (id)
    
    if id then
      self.mail_list[id]:MailDelete()
    end
    
  end)
end
function PopupMail:OnDestroy()
  Event:UnRegister(Constant.Event.ReceiveMail, self.eventID1)
end
function PopupMail:OnBeginShow()
  self:RemoveMailItem()
  self:AddMailItem()
  
end

function PopupMail:RemoveMailItem()
  local allChild = self.email_container:GetAllChild()
  for key, value in pairs(allChild) do
    self:Destroy(value.gameObject)
  end
end

function PopupMail:AddMailItem()
  local mail_list=Me:get_mails()
  for k,v in pairs(mail_list) do
    local clone_mail=self:Instantiate(self.email)
    clone_mail.transform:SetParent(self.email_container)
    ---@type MailPrefab
    local mail_prefab=clone_mail:GetComponent("MailPrefab")
    mail_prefab:SetData(v)
    
    self.mail_list[v.UUID]=mail_prefab
  end
  self.exit:onClickAddListener(function()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(self.PopupID)
    
  end)
end

function PopupMail:OnEndShow()
  
end

function PopupMail:OnBeginHide()
 
end

function PopupMail:OnEndHide()

end

function PopupMail:close()

  PopupManager:hide(self.PopupID)
end

_G.Popup_test = PopupMail
