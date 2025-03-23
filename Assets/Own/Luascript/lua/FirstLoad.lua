---@class FirstLoad : MonoBehaviour
local FirstLoad = class("FirstLoad", MonoBehaviour)
FirstLoad.__path = __path

function FirstLoad:Start()
    if not ShopManager.isLoaded then
        ShopManager.Instance:GetFishShop()
        ShopManager.Instance:GetDecorationShop()
        ShopManager.Instance:GetStallShop()
        ShopManager.isLoaded = true
    end
end

_G.FirstLoad = FirstLoad