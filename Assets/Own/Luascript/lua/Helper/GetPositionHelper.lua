---@class GetPositionHelper : MonoBehaviour
---@field namePos string
local GetPositionHelper = class("GetPositionHelper", MonoBehaviour)
GetPositionHelper.__path = __path

function GetPositionHelper:Awake()
    Event:RegisterRequestData(self.namePos, function (param,callBack)
        callBack(self.transform:GetPosition())
    end)
end

function GetPositionHelper:OnDestroy()
    Event:RemoveRequestData(self.namePos)
end

_G.GetPositionHelper = GetPositionHelper
