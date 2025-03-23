---@class PopupRanking : MonoBehaviour
local PopupRanking = class("PopupRanking", MonoBehaviour)
PopupRanking.__path = __path

function PopupRanking:Close()
    PopupManager:hide(self.PopupID)
end

_G.PopupRanking = PopupRanking
