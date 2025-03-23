---@class ToolBar : MonoBehaviour
---@field ChatBtn Button
local ToolBar = class("ToolBar", MonoBehaviour)
ToolBar.__path = __path

function ToolBar:Awake()
  
end

function ToolBar:OnDestroy()
  
end

function ToolBar:Update()

end

function ToolBar:Start()
   self.ChatBtn:onClickAddListener(function ()
      AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
      PopupManager:show(Constant.PoppupID.Popup_Chat)
   end)
end


_G.ToolBar = ToolBar
