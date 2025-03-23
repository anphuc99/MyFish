---@class BackFriendZone : MonoBehaviour
local BackFriendZone = class("BackFriendZone", MonoBehaviour)
BackFriendZone.__path = __path

function BackFriendZone:OnClick()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    Event:Emit(Constant.Event.OnOutFriendZone)
end

_G.BackFriendZone = BackFriendZone
