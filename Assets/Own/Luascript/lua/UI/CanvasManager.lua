---@class CanvasManager : MonoBehaviour
---@field canvas GameObject
local CanvasManager = class("CanvasManager", MonoBehaviour)
CanvasManager.__path = __path

function CanvasManager:Awake()
    Event:RegisterRequestData(Constant.Request.Canvas, Lib.handler(self, self.GetCanvas))
end

function CanvasManager:OnDestroy()
    Event:RemoveRequestData(Constant.Request.Canvas)
end

function CanvasManager:GetCanvas(params, callback)
    callback(self.canvas)
end

_G.CanvasManager = CanvasManager
