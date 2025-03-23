
---@class News : MonoBehaviour
---@field image SpriteRenderer
local News = class("News", MonoBehaviour)
News.__path = __path

local mainurl, moreinfourl

function News:Start()
    mainurl = "https://t.ly/dACSX"
    moreinfourl = "https://github.com/DevMini-Studio"
   --self.image:SetSprite(mainurl)
end

_G.News = News
