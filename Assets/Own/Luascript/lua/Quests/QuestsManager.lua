---@class QuestsManager : MonoBehaviour
---@field questItem QuestsItem
---@field content Transform
local QuestsManager = class("QuestsManager", MonoBehaviour)
QuestsManager.__path = __path

function QuestsManager:Start()
    self:RemoveAll()
    local questData = Me:GetQuests()
    self:Install(questData)
end

function QuestsManager:RemoveAll()
    local allChild = self.content:GetAllChild()
    for k, child in pairs(allChild) do
        self:Destroy(child.gameObject)
    end
end

function QuestsManager:Install(data)
    for i, v in ipairs(data) do
        ---@type QuestsItem
        local quest = self:Instantiate(self.questItem)
        quest.parent = self
        quest.transform:SetParent(self.content)
        quest:SetQuatity(v.CurQuantity, v.Quantity)
        quest:SetTitle(v.Type)
    end
end

function QuestsManager:Close()
    PopupManager:hide(self.PopupID)
end
_G.QuestsManager = QuestsManager

