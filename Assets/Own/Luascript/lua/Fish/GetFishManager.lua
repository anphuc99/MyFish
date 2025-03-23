---@class GetFishManager : MonoBehaviour
---@field FishPrefabTable table
local GetFishManager = class("GetFishManager", MonoBehaviour)
GetFishManager.__path = __path

function GetFishManager:Awake()
    GetFishManager.Instance = self
end

function GetFishManager:GetFishPref(uid)    
    return self.FishPrefabTable[uid..""]
end


_G.GetFishManager = GetFishManager
