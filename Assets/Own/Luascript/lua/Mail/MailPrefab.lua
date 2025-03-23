---@class MailPrefab : MonoBehaviour
---@field title TextMeshProGUI
---@field btn_view Button
local MailPrefab = class("MailPrefab", MonoBehaviour)
MailPrefab.__path = __path


function MailPrefab:Awake()
   
end

function MailPrefab:OnDestroy()
    self.btn_view:onClickRemoveAll()
end

function MailPrefab:Start()
    self.btn_view:onClickAddListener(Lib.handler(self, self.OnMouseDown))
end

function MailPrefab:SetData(classMail)
    if classMail and not self.classMail then
        self.classMail= classMail
        
    end
    if not self.properties then
        self.properties={}
    end
    
    for k,v in pairs(classMail:get()) do
        self.properties[tostring(k)]=v
    end
    if  self.properties["title"] then
        
        self.title:SetText(self.properties["title"])
    end
end


function MailPrefab:Update()    
    
   
end

function MailPrefab:OnMouseDown()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(Constant.PoppupID.Popup_Email)
 
    PopupManager:show(Constant.PoppupID.Popup_EmailDetail, {
        properties=self.properties
    })
end

function MailPrefab:MailDelete()
    self:Destroy(self.gameObject)
end
_G.MailPrefab = MailPrefab