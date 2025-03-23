---@class NextLevel : MonoBehaviour
---@field LevelTxt TextMeshProGUI
---@field LevelUI GameObject
local NextLevel = class("NextLevel", MonoBehaviour)
NextLevel.__path = __path
function NextLevel:Start()
    self.isEnable = false
    self.LevelUI:SetActive(false)
    self.LevelTxt:SetText(self:getStr())
end

function NextLevel:OpenLevelUI()
    self.isEnable = not self.isEnable
    self.LevelUI:SetActive(self.isEnable)
    if not self.isEnable then
        self.LevelTxt:SetText(self:getStr())
    end
end

function NextLevel:getStr()
    local LocalPlayer = Me:get_player()
    local data = LocalPlayer:get()
    local curExp = data.lv_exp
    local nxtExp = data.lv_maxExp
    local level = tostring(curExp) .. "/" .. tostring(nxtExp)
    return level
end

_G.NextLevel = NextLevel
