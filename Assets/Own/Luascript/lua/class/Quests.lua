---@class Quests 
local Quests = class("Quests")

function Quests:ctor(value)
    self.Type = value.mission_type
    self.State = value.State
    self.Quantity = value.quantity
    self.CurQuantity = value.current_quantity
    self.Gold = value.gold_reward
    self.Exp = value.exp_reward
end



_G.Quests = Quests