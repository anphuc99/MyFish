-- SceneLoader:LoadData() -- mở scene loader
-- SceneLoader:SetValue(0.5) -- chỉnh thanh tiến độ load data
-- SceneLoader:Load("GamePlay") -- load scene GamePlay lên

Lib.CheckGlobal("Me")
Me = MeClass.new()

local load={player=false,aquarium=false,fish_master=false,fish_shop=false}

local IAPPack = {
    [Constant.IAP.GPoint20K] = ProductType.Consumable,
    [Constant.IAP.GPoint50K] = ProductType.Consumable,
    [Constant.IAP.GPoint100K] = ProductType.Consumable,
    [Constant.IAP.GPoint200K] = ProductType.Consumable,
    [Constant.IAP.GPoint500K] = ProductType.Consumable,
}

InAppPurchase:Initialize(IAPPack)

---#class Instance
MailManager.new()
FriendManager.new()
FishMaster:Init()
PlayerSocket:SignalPlayerChange()
---#end

SceneLoader:LoadData()

ShopSocket:GetFish()
ShopSocket:GetDecoration()
ItemSocket:GetItem()

BagSocket:GetItem()

local process=0
local numProcess=13
local scene = Constant.Scene.GamePlay
PlayerSocket:getPlayer(function(resp)
    local inform = resp.data
    if resp.code == 2 then
        scene = Constant.Scene.CreateUser
        process = numProcess
    else
        Me:InitPlayer(inform)
        process=process+1        
    end
end)
PlayerSocket:getMail(function(data)
    process=process+1
end)
AquariumSocket:GetAquarium(function(data)
    process=process+1
end)
FishMaster:getOnServer(function(data)
    process=process+1
end)
FishMaster:getShopOnServer(function(data)
    process=process+1
end)

FriendSocket:GetListFriend(function (resp)
    if resp.code == 1 then
        Me:InitFriend(resp.data.list)
    end
    process = process+1
end)

FriendSocket:GetRequestFriend(function (resp)
    if resp.code == 1 then
        Me:InitRequestFriend(resp.data.list)
    end
    process = process+1
end)

CurrencySocket:GetCurrency(function (resp)
    Me:SetCurrentCyExchange(resp.data.currency_exchange_rate)
    process = process+1
end)

RankingSocket:getRankLevel(function (resp)
    if resp.code == 1 then
        Me:InitRanking(resp.data.ranking, Constant.Ranking.Level)
        process = process+1
    end
end)

RankingSocket:getRankFishOpen(function (resp)
    if resp.code == 1 then
        Me:InitRanking(resp.data.ranking, Constant.Ranking.FishOpen)
        process = process+1
    end
end)

RankingSocket:getRankPoint(function (resp)
    if resp.code == 1 then
        Me:InitRanking(resp.data.ranking, Constant.Ranking.Point)
        process = process+1
    end
end)

RankingSocket:getRankCoin(function (resp)
    if resp.code == 1 then
        Me:InitRanking(resp.data.ranking, Constant.Ranking.Coin)
        process = process+1
    end
end)

QuestsSocket:getDaily(function (resp)
    if resp.code == 1 then
        --Lib.pv(resp.data.missions)
        Me:InitQuests(resp.data.missions)
        process = process+1
    end

end)

ChatSocket:RegisterServerSendChat()

Time:startTimer(1,function()

    if process < numProcess then
        SceneLoader:SetValue(process/numProcess)
        return true
    else
        SceneLoader:SetValue(1)
        SceneLoader:Load(scene)
    end
    
end)
-- while load.player==false and load.aquarium==false and load.fish_master==false and load.fish_shop==false do
--     process=process+0.001
--     SceneLoader:SetValue(process)
--     if process>=1 then
--         load.player=true
--     end
-- end



