---@class RankingTab : MonoBehaviour
---@field rankingItem RankingItem
---@field content Transform
---@field type string
local RankingTab = class("RankingTab", MonoBehaviour)
RankingTab.__path = __path

function RankingTab:Start()
    self:RemoveAll()
    local rankData = Me:GetRanking(self.type)
    self:Install(rankData)
end

function RankingTab:RemoveAll()
    local allChild = self.content:GetAllChild()
    for k, child in pairs(allChild) do
        self:Destroy(child.gameObject)
    end
end

function RankingTab:Install(data)
    for i, v in ipairs(data) do
        ---@type RankingItem
        local ranking = self:Instantiate(self.rankingItem)
        ranking:SetFriend(v)
        ranking:SetRank(i)
        ranking.parent = self
        ranking.transform:SetParent(self.content)
    end
end

function RankingTab:ShowInfomation(item)
    local player = Me:get_player()    
    if player.UUID ~= item.UUID then
        PopupManager:show(Constant.PoppupID.Popup_InfoFriend, {data = item})        
    end
end

_G.RankingTab = RankingTab
