---@class PhotoManager : MonoBehaviour
---@field view GameObject
---@field hideUIs table
local PhotoManager = class("PhotoManager", MonoBehaviour)
PhotoManager.__path = __path

function PhotoManager:Awake()
    PhotoManager.Instance = self
end

function PhotoManager:OnPhotoMode()
    for index, value in pairs(self.hideUIs) do
        value:SetActive(false)
    end
    self.view:SetActive(true)
end

function PhotoManager:OffPhotoMode()
    for index, value in pairs(self.hideUIs) do
        value:SetActive(true)
    end
    self.view:SetActive(false)
end

function PhotoManager:OnDecorMode()
    for index, value in pairs(self.hideUIs) do
        value:SetActive(false)
    end
end

function PhotoManager:OffDecorMode()
    for index, value in pairs(self.hideUIs) do
        value:SetActive(true)
    end
end

_G.PhotoManager = PhotoManager