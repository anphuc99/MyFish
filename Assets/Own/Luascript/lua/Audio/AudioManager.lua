---@class AudioManager : MonoBehaviour
---@field BgSound AudioSource
---@field SoundEffect table
local AudioManager = class("AudioManager", MonoBehaviour)
AudioManager.__path = __path

function AudioManager:Awake()
    AudioManager.Instance = self
    self.evOnChangVolume = Event:Register(Constant.Event.OnChangeVolume, Lib.handler(self, self.OnChangeVolume))    
    self.BgSound:Play()
    self:Refresh()
end

function AudioManager:OnDestroy()
    Event:UnRegister(Constant.Event.OnChangeVolume, self.evOnChangVolume)
end

function AudioManager:Refresh()
    local volume = DataLocalManager:GetValue(Constant.Data.volume) or 100
    local sound = DataLocalManager:GetValue(Constant.Data.sound) or 100
    self.BgSound:SetVolume(volume/100)
    for key, value in pairs(self.SoundEffect) do
        ---@type AudioSource
        local soundEffect = value
        soundEffect:SetVolume(sound/100)
    end
end

function AudioManager:OnChangeVolume()
    self:Refresh()
end

function AudioManager:PlaySoundEffect(soundEffect)
    ---@type AudioSource
    local soundEffect = self.SoundEffect[soundEffect]
    soundEffect:Play()
end

_G.AudioManager = AudioManager
