
---@class AquariumFriendManager : AquariumManager
local AquariumFriendManager, base= class("AquariumFriendManager", AquariumManager)
AquariumFriendManager.__path = __path

function AquariumFriendManager:SendFood()
    local UUID = Me:get_player().UUID
    for key, value in pairs(self.listFishFeed) do
        local foodID = key
        AquariumSocket:feedFriendFish(foodID, value, UUID, self.curAquarium or 1)
    end
    self.timerID = nil
    self.listFishFeed = {}
end

function AquariumFriendManager:OnChangeAquarium(index)
    if self.curAquarium or 1 ~= index then
        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = "Bạn có muốn đổi hồ cá không?",
            btnYes = {
                text = "Đồng Ý",
                onClick = function()               
                        AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                        PopupManager:hide(Constant.PoppupID.Popup_Notification)
                        self.curAquarium = index
                        SceneLoader:LoadData()
                        Time:startTimer(0.5, function ()
                            SceneLoader:LoadCurScene()                        
                        end)
                    end
            },
            btnNo = {
                text = "Hủy",
                onClick = function ()
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                end
            }
        })        
    end
end

_G.AquariumFriendManager = AquariumFriendManager
