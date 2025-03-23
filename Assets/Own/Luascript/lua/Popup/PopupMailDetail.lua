---@class PopupMailDetail : MonoBehaviour
---@field btn_yes Button
---@field btn_no Button
---@field content TextMeshProGUI
---@field ListItemContent Transform
---@field ItemPrefab GameObject
local PopupMailDetail = class("PopupMailDetail", MonoBehaviour)
PopupMailDetail.__path = __path

function PopupMailDetail:Start()
    self.btn_no:onClickAddListener(function()
        PopupManager:hide(self.PopupID)
    end)
end

function PopupMailDetail:OnBeginShow()
    local mail_properties = self.params.properties
    self.content:SetText(mail_properties.content)
    self.btn_yes:onClickAddListener(function()
        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
        MailSocket:ReceiveMail(mail_properties.UUID, Lib.handler(self, self.OnReceive))
        PopupManager:hide(self.PopupID)
    end)

    for k, v in pairs(mail_properties.item_list) do
        local clone_item = self:Instantiate(self.ItemPrefab)
        clone_item.transform:SetParent(self.ListItemContent)
        ---@type MailItemPrefab
        local mail_prefab = clone_item:GetComponent("MailItemPrefab")
        mail_prefab:SetData(k, v)
    end
end

function PopupMailDetail:OnReceive()
    local mail_properties = self.params.properties
    local reward = {}
    local index = 1
    for key, value in pairs(mail_properties.item_list) do
        reward[tostring(index)] = {
            UID = key,
            amount = value
        }
    end
    PopupManager:show(Constant.PoppupID.Popup_Reward, reward)
end

function PopupMailDetail:OnEndShow()

end

function PopupMailDetail:OnBeginHide()
    self.btn_yes:onClickRemoveAll()
    local allChild = self.ListItemContent:GetAllChild()
    for key, child in pairs(allChild) do
        self:Destroy(child.gameObject)
    end
end

function PopupMailDetail:OnEndHide()

end

function PopupMailDetail:close()
    PopupManager:hide(self.PopupID)
end

_G.Popup_test = PopupMailDetail
