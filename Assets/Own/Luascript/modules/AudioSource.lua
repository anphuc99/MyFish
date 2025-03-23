---@class AudioSource : Component
AudioSource = class("AudioSource", Component)

function AudioSource:Play()
    APIAudioSource.Play(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function AudioSource:Stop()
    APIAudioSource.Stop(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

function AudioSource:SetVolume(volume)
    APIAudioSource.SetVolume(self.gameObject:GetInstanceID(), self:GetInstanceID(), volume)
end

function AudioSource:GetVolume()
    APIAudioSource.GetVolume(self.gameObject:GetInstanceID(), self:GetInstanceID())
end

---@param audioClip AudioClip
function AudioSource:SetAudioClip(audioClip)
    APIAudioSource.SetAudioClip(self.gameObject:GetInstanceID(), self:GetInstanceID(), audioClip:GetInstanceID())
end

function AudioSource:GetAudioClip()
    local InsAudioClip = APIAudioSource.GetAudioClip(self.gameObject:GetInstanceID(), self:GetInstanceID())
    return Lib.GetOrAddAudioClip(InsAudioClip)
end