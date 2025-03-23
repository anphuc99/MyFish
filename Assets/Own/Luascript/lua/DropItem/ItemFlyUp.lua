---@class ItemFlyUp : MonoBehaviour
---@field txtNumber TextAmount
local ItemFlyUp = class("ItemFlyUp", MonoBehaviour)
ItemFlyUp.__path = __path

function ItemFlyUp:Start()
    Event:RequestData(Constant.Request.Canvas, nil, function(canvas)
        self.canvas = canvas
    end)
end

function ItemFlyUp:OnEnable()
    self.isCollect = 0
end

function ItemFlyUp:OnDestroy()
    Time:stopTimer(self.timerID)
end

---@param targetPos GameObject
---@param itemId string
---@param amount number
---@param aquarium number
function ItemFlyUp:Initilize(targetPos, itemId, amount, aquarium)
    self.target = targetPos
    self.itemId = tostring(itemId)
    self.amount = amount
    self.aquarium = aquarium and aquarium or nil
    self.initPos = self.transform:GetPosition()
    self.fromAqua = true
    self:Move()
end

---@param targetPos GameObject
---@param itemId string
---@param amount number
function ItemFlyUp:Initilize1(targetPos, itemId, amount)
    self.target = targetPos
    self.itemId = tostring(itemId)
    self.amount = amount
    self:Fly()
end

function ItemFlyUp:Move()
    local x = self.initPos.x + (-0.1 + math.random() * 2 * 0.1)
    local y = self.initPos.y + (-0.5 + math.random() * 1.6 * 0.5)
    local endPoint = Vector3.new(x, y, 0)
    self.tween = LeanTween:move(self.gameObject, endPoint, math.random(1, 2)):setOnComplete(function()
        self:Move()
    end)
end

function ItemFlyUp:OnMouseDown()
    if (self.isCollect == 0) then
        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.CollectPoints)
        self:ShowNumber(self.amount)
        self:Fly(true)
    end
end

function ItemFlyUp:ShowNumber(amount)
    ---@type TextAmount
    local num = self:Instantiate(self.txtNumber)
    num.transform:SetParent(self.canvas.transform)
    num:SetAmount(amount)
    local v3 = Vector3.Copy(self.transform:GetPosition())
    v3.y = v3.y + 1
    num.transform:SetPosition(v3)
    self.timerID = Time:startTimer(1, function()
        self:Destroy(num.gameObject)
    end)
end

function ItemFlyUp:Fly()
    ---@type Vector3
    local targetPos = self.target.transform:GetPosition()
    if (self.isCollect == 0) then
        self.isCollect = 1
        if self.itemId == Constant.Currency.Gold then
            LeanTween:scale(self.gameObject, Vector3.new(0.7, 0.7, 0.7), 2);
        else
            LeanTween:scale(self.gameObject, Vector3.new(0.3, 0.3, 0.3), 2);
        end

        LeanTween:move(self.gameObject, targetPos, 2)
            :setOnComplete(function()
                if (self.fromAqua) then
                    self.parent:FlyComplete(self)
                    local packet = {
                        code = 1,
                        id = self.itemId,
                        amount = self.amount,
                        aquarium = self.aquarium
                    }
                    Me:CollectDropUp(packet)
                end
                self:Destroy(self.gameObject)
            end)
            :setEase(LeanTweenType.easeInBack)
    end
end

_G.ItemFlyUp = ItemFlyUp
