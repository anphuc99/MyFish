---@class Popup_Quests : MonoBehaviour
local Popup_Quests = class("Popup_Quests", MonoBehaviour)
Popup_Quests.__path = __path

function Popup_Quests:Close()
    PopupManager:hide(self.PopupID)
end

_G.Popup_Quests = Popup_Quests
