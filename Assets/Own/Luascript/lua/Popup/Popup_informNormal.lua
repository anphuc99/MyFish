---@class Popup_informNormal : MonoBehaviour
---@field name TextMeshProGUI
---@field lv TextMeshProGUI
---@field truongthanh_slide Slider
---@field truongthanh_time TextMeshProGUI
---@field doi_slide Slider
---@field doi_time TextMeshProGUI
---@field bonus_exp TextMeshProGUI
---@field bonus_coin TextMeshProGUI
---@field price_exp TextMeshProGUI
---@field price_coin TextMeshProGUI
---@field exit Button
---@field gender Image
---@field gender_image table
local Popup_informNormal = class("Popup_informNormal", MonoBehaviour)
Popup_informNormal.__path = __path
local popup_show = false
function Popup_informNormal:SecondsToCountdown(seconds)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local remainingSeconds = math.floor(seconds % 60)

  return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
end

function Popup_informNormal:OnBeginShow()
  popup_show = true
  local id = self.params.id
  -- local fish_inform=FishMaster.List[tostring(fish.UID)]
  local FishClass = Me:get_fish_by_id(id)
  local inform = FishClass:get()
  if FishClass then
    local fish_inform = FishMaster.List[tostring(FishClass.UID)]
    self.name:SetText(fish_inform.name)
    self.lv:SetText(inform.level)
    self.bonus_coin:SetText(inform.bonus.coin)
    self.bonus_exp:SetText(inform.bonus.exp)
    self.price_exp:SetText(fish_inform.growth.exp)
    self.price_coin:SetText(fish_inform.growth.coin)
    local hungry_time = FishClass:getHungryTime()
    if inform.gender>1 then
      self.gender:SetSprite(self.gender_image.female)
    else
      self.gender:SetSprite(self.gender_image.male)
    end
    self.doi_time:SetText(self:SecondsToCountdown(hungry_time))
    self.doi_slide:SetValue(1 - FishClass:getScaleHungryTimeSlide())

    local adult_time = FishClass:timeAdultRemaining()
    self.truongthanh_time:SetText(self:SecondsToCountdown(adult_time))
    self.truongthanh_slide:SetValue(FishClass:getScaleAdultTimeSlide())
    self.timerID = Time:startTimer(0.5, function()
      local hungry_time = FishClass:getHungryTime()
      self.doi_time:SetText(self:SecondsToCountdown(hungry_time))
      self.doi_slide:SetValue(1 - FishClass:getScaleHungryTimeSlide())

      local adult_time = FishClass:timeAdultRemaining()
      self.truongthanh_time:SetText(self:SecondsToCountdown(adult_time))
      self.truongthanh_slide:SetValue(FishClass:getScaleAdultTimeSlide())
      return popup_show
    end)
  else
    PopupManager:hide(self.PopupID)
  end
  self.exit:onClickAddListener(function()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(self.PopupID)
    popup_show = false
    self.exit:onClickRemoveAll()
  end)
end

function Popup_informNormal:OnEndShow()

end

function Popup_informNormal:OnBeginHide()
  popup_show = false
end

function Popup_informNormal:OnEndHide()
  Time:stopFramer(self.timerID)
end

function Popup_informNormal:close()
  popup_show = false
  PopupManager:hide(self.PopupID)
end

_G.Popup_test = Popup_informNormal
