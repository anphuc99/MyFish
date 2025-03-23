---@class PopupLevelUp : MonoBehaviour
---@field level TextMeshProGUI
---@field btn_no Button
local PopupLevelUp = class("PopupLevelUp", MonoBehaviour)
PopupLevelUp.__path = __path
function PopupLevelUp:Start()
  self.btn_no:onClickAddListener(function()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(self.PopupID)
  end)
end

function PopupLevelUp:OnBeginShow()
  AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.LevelUp)
  local lv = self.params.lv
  if lv then
    self.level:SetText(lv)
  end
  PopupManager:LockUI(true)
  Time:startTimer(2, function ()
    PopupManager:LockUI(false)
  end)
end

function PopupLevelUp:OnEndShow()

end

function PopupLevelUp:OnBeginHide()

end

function PopupLevelUp:OnEndHide()

end

function PopupLevelUp:close()
  PopupManager:hide(self.PopupID)
end

_G.Popup_test = PopupLevelUp
