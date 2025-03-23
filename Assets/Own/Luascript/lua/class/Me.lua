---@class Me
local MeClass = class("MeClass")

function MeClass:ctor()
    self.data = {
        current_index = 1,
        player = {},
        aquarium = {}, --{[1]={inform=ClassAquarium,fish={ClassFish,ClassFish}}}
        shop = {
            fish = {},
            decoration = {},
            stall = {}
        },
        bag = {
            fish = {},
            decoration = {},
            item = {}
        },
        decor = {},
        mail = {}, --[id-mail]=MailClass
        chat = {},
        item = {},
        Friend = {},
        Ranking = {
            Level = {},
            Coin = {},
            Point = {},
            FishOpen = {}
        },
        Quests = {
        }
    }
end

function MeClass:setIndex(index)
    self.data.current_index = index
end

function MeClass:getIndex()
    return self.data.current_index
end

function MeClass:InitPlayer(properties)
    self.data.player = Player.new(properties)
    return self.data.player
end

---------------INIT DATA --------------------

function MeClass:InitBagDecoration(properties_list)
    local i = 0
    for k, v in pairs(properties_list) do
        self.data.bag.decoration[i] = _BagDecoration.new(v)
        i = i + 1
    end
end

function MeClass:InitAquarium(properties_list, UUID)
    for k, v in pairs(properties_list) do
        self.data.aquarium[v.index] = {}
        self.data.aquarium[v.index].fish = {}
        self.data.aquarium[v.index].inform = Aquarium.new(v)
        --Lib.pv(data.aquarium[v.index].inform:get())
        FishSocket:GetFishByIndex(v.index, UUID)
    end
end

function MeClass:CountAquarium()
    return #self.data.aquarium
end

function MeClass:InitAddFishByAquarium(index, properties)
    if self.data.aquarium[index].inform then
        self.data.aquarium[index].fish[properties.id] = Fish1.new(properties)
    end
end

function MeClass:InitShopFish(inform)
    for index, value in pairs(inform) do
        self.data.shop.fish[tostring(value.UID)] = ShopFish.new(value)
    end
end

function MeClass:InitMail(inform)
    for index, value in pairs(inform) do
        self.data.mail[value.UUID] = Mail.new(value)
    end
    Event:Emit(Constant.Event.UpdateNotify, "mail")
end

function MeClass:InitItem(inform)
    for index, value in pairs(inform) do
        if value.price then
            self.data.item[tostring(value.UUID)] = ShopStall.new(value)
            self.data.shop.stall[tostring(value.UUID)] = self.data.item[tostring(value.UUID)]
        else
            self.data.item[tostring(value.UUID)] = Item.new(value)
        end
    end
end

function MeClass:InitShopDecoration(inform)
    for index, value in pairs(inform) do
        self.data.shop.decoration[value.UUID] = ShopDecoration.new(value)
    end
end

function MeClass:InitChat(inform)

end

function MeClass:InitFriend(inform)
    for key, value in pairs(inform) do
        self.data.Friend[value.friendCode] = Friend.new(value, true)
    end
end

function MeClass:InitRequestFriend(inform)
    for key, value in pairs(inform) do
        self.data.Friend[value.friendCode] = Friend.new(value, false)
    end
end

---------------END INIT DATA --------------------
---@return ShopFish[]
function MeClass:GetShopFish()
    return self.data.shop.fish
end

---@return ShopFish
function MeClass:GetShopFishByID(UID)
    return self.data.shop.fish[tostring(UID)]
end

---@return ShopDecoration
function MeClass:GetShopDecoration()
    return self.data.shop.decoration
end

---@return Item[]
function MeClass:GetItem()
    return self.data.item
end

---@return Item
function MeClass:GetItemByID(UID)
    return self.data.item[tostring(UID)]
end

---@return ShopStall[]
function MeClass:GetShopStall()
    return self.data.shop.stall
end

---@return ShopStall
function MeClass:GetShopStallByID(UID)
    return self.data.shop.stall[tostring(UID)]
end

---@return Player
function MeClass:get_player()
    return self.data.player
end

---@return Aquarium
function MeClass:get_aquarium()
    return self.data.aquarium
end

function MeClass:get_fish_by_index(index)
    return self.data.aquarium[index].fish
end

---@return Fish1
function MeClass:get_fish_by_id(id)
    for k, v in pairs(self.data.aquarium) do
        for _id, _v in pairs(v.fish) do
            if _id == id then
                return v.fish[_id]
            end
        end
    end
    return nil
end

function MeClass:remove_fish_by_id(id)
    for k, v in pairs(self.data.aquarium) do
        for _id, _v in pairs(v.fish) do
            if _id == id then
                v.fish[_id] = nil
                return
            end
        end
    end
end

---@return Fish1
function MeClass:add_fish_by_id_index(properties, index)
    if properties.id then
        self.data.aquarium[index].fish[properties.id] = Fish1.new(properties)
        return self.data.aquarium[index].fish[properties.id]
    end
    return nil
end

---@return _BagDecoration
function MeClass:GetBagDecoration()
    return self.data.bag.decoration
end

-- ==========BAG ITEM==========

-- Init: khởi tạo giá trị ban đầu
function MeClass:InitBagItem(inform)
    for index, value in pairs(inform) do
        table.insert(self.data.bag.item, _BagItem.new(value))
    end
end

-- Get: lấy, đọc giá trị
---@return _BagItem[]
function MeClass:GetBagItem()
    return self.data.bag.item
end

function MeClass:CheckBagExistItemByUID(UID)
    local data = self:GetItem()
    for key, value in pairs(data) do
        if value.UID == UID then
            return true
        end
    end
    return false
end

-- Add: thêm giá trị, nếu chưa có thì tạo
-- return isFirstInit
function MeClass:AddBagItem(UID)
    local item = self:GetBagItemByUID(UID)

    if item == nil then
        table.insert(self.data.bag.item, _BagItem.new({ id = UID, amount = 1 }))
        return true
    else
        item.amount = item.amount + 1
        return false
    end
end

-- Subtract: giảm giá trị, nếu = 0 thì xóa
-- return isDeleted
function MeClass:SubtractBagItem(UID)
    local item = self:GetBagItemByUID(UID)

    item.amount = item.amount - 1

    if item.amount == 0 then
        local index = self:GetBagItemIndexByUID(UID)
        table.remove(self.data.bag.item, index)
        return true
    else
        return false
    end
end

-- Lấy item bằng UID
function MeClass:GetBagItemByUID(UID)
    for key, value in pairs(self.data.bag.item) do
        if value.UID == UID then
            return self.data.bag.item[key]
        end
    end
    return nil
end

-- Lấy index item bằng UID
function MeClass:GetBagItemIndexByUID(UID)
    for key, value in pairs(self.data.bag.item) do
        if value.UID == UID then
            return key
        end
    end
end

-- Lấy ra food đầu tiên nếu không có trả về nil
function MeClass:FirstOrDefaultFoodInBag()
    for key, value in pairs(self.data.bag.item) do
        for k, v in pairs(Constant.Food) do
            if value.UID == v then
                return value
            end
        end
    end
    return nil
end

-- Sắp xếp item trong bag
function MeClass:SortBagItem()
    table.sort(self.data.bag.item, function(a, b)
        return a.UID < b.UID
    end)
end

-- ============================

-- ==========DECOR ITEM==========

-- Init: khởi tạo giá trị ban đầu
function MeClass:InitDecorItem()
    local bag_decoration = self:get_player():get().bag_decoration
    for index, value in pairs(bag_decoration) do
        table.insert(self.data.decor, _DecorItem.new(value))
    end
end

-- Get: lấy, đọc giá trị
function MeClass:GetDecorItem()
    return self.data.decor
end

-- Kiểm tra xem item đó đã có chưa
-- return isFirstInit
function MeClass:IsFirstInitDecorItem(UID)
    local item = self:GetDecorItemByUID(UID)

    if item == nil then
        table.insert(self.data.decor, _DecorItem.new({ id = UID, amount = 1 }))
        return true
    else
        item.amount = item.amount + 1
        return false
    end
end

-- Kiểm tra xem item đó đã bị xóa chưa
-- return isDeleted
function MeClass:IsDeletedDecorItem(UID)
    local item = self:GetDecorItemByUID(UID)

    item.amount = item.amount - 1

    if item.amount == 0 then
        local index = self:GetDecorItemIndexByUID(UID)
        table.remove(self.data.decor, index)
        return true
    else
        return false
    end
end

-- Lấy item bằng UID
function MeClass:GetDecorItemByUID(UID)
    for key, value in pairs(self.data.decor) do
        if value.UID == UID then
            return self.data.decor[key]
        end
    end
    return nil
end

-- Lấy index item bằng UID
function MeClass:GetDecorItemIndexByUID(UID)
    for key, value in pairs(self.data.decor) do
        if value.UID == UID then
            return key
        end
    end
end

-- ============================

function MeClass:get_mails()
    return self.data.mail
end

function MeClass:get_mail_by_UUID(UUID)
    return self.data.mail[UUID]
end

function MeClass:add_mail(value)
    self.data.mail[value.UUID] = Mail.new(value)
end

function MeClass:delete_mail_by_UUID(UUID)
    self.data.mail[UUID] = nil
    return self.data.mail[UUID] == nil
end

---@return Friend[]
function MeClass:GetFriend()
    return self.data.Friend
end

function MeClass:AddFriend(value, isFriend)
    if not self.data.Friend[value.friendCode] then
        self.data.Friend[value.friendCode] = Friend.new(value, isFriend)
    end
end

function MeClass:RemoveFriend(friendCode)
    self.data.Friend[friendCode] = nil
end

function MeClass:SetCurrentCyExchange(CurrencyExchangeRate)
    self.data.currency_exchange_rate = CurrencyExchangeRate
end

function MeClass:GetCurrencyPointToGold()
    return self.data.currency_exchange_rate.point_to_coin
end

function MeClass:GetCurrencyPointToDimond()
    return self.data.currency_exchange_rate.point_to_diamond
end

function MeClass:InitRanking(rank, type)
    for index, value in ipairs(rank) do
        ---@type Friend
        local friend = Friend.new(value)
        table.insert(self.data.Ranking[type], friend)
    end
end

---@return Friend[]
function MeClass:GetRanking(type)
    return self.data.Ranking[type]
end

function MeClass:CollectDropUp(packet)
    local curAqua = packet.aquarium
    local data = self.data.aquarium[curAqua].inform:get()
    local dropItem = data[Enum.Aquarium.DROP_ITEM]
    local curValue = dropItem[tostring(packet.id)]
    dropItem[tostring(packet.id)] = curValue - packet.amount
end

function MeClass:InitQuests(data)
    for index, value in ipairs(data) do
        ---@type Quests
        local quests = Quests.new(value)
        --Lib.pv(quests)
        table.insert(self.data.Quests, quests)
    end
end

function MeClass:GetQuests()
    return self.data.Quests
end

_G.MeClass = MeClass
