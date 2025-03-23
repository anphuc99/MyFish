FirebaseRemoteConfig = {}

---@param key string
---@return string
function FirebaseRemoteConfig:GetValue(key)
    return APIFirebaseRemoteConfig.GetValue(key)
end

---@param key string
---@param value string
function FirebaseRemoteConfig:SetDefaultValue(key, value)
    return APIFirebaseRemoteConfig.SetDefaultValue(key, value)
end