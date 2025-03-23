---@class RankingItem : FriendItem
---@field txtRank TextMeshProGUI
---@field topRank GameObject
local RankingItem = class("RankingItem", FriendItem)
RankingItem.__path = __path

function RankingItem:SetRank(rank)
    self.txtRank:SetText(rank)
    self.topRank:SetActive(rank == 1 or rank == 2 or rank == 3)
end

_G.RankingItem = RankingItem
