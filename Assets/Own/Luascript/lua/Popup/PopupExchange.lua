---@class PopupExchange : MonoBehaviour
---@field item table
---@field name string
---@field type string
local PopupExchange = class("PopupExchange", MonoBehaviour)
PopupExchange.__path = __path

function PopupExchange:OnBeginShow()
    self.data = self.params.data
    local index = 1
    for value1, value2 in pairs(self.data) do
        ---@type ExchangeItem
        local item = self.item[tostring(index)]
        item:SetValue(value1, value2)
        item.parent = self
        index = index + 1
    end
end

function PopupExchange:OnExchange(item)
    PopupManager:show(Constant.PoppupID.Popup_Notification, {
        title = "THÔNG BÁO",
        desrciption = "Bạn có muốn đổi "..item.v1.." GPoint sang "..item.v2.." "..self.name.." không?",
        btnYes = {
            text = "Đồng Ý",
            onClick = function()
                    self:YesChange(item)
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                end
        },
        btnNo = {
            text = "Hủy",
            onClick = function ()
                AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                PopupManager:hide(Constant.PoppupID.Popup_Notification)
            end
        }
    })
end

function PopupExchange:YesChange(item)
    CurrencySocket:Exchange(self.type, tonumber(item.v1), function (resp)        
        Time:startTimer(1, function ()
            if resp.code == 1 then
                PopupManager:show(Constant.PoppupID.Popup_Notification, {
                    title = "THÔNG BÁO",
                    desrciption = "Đổi thành công",
                    btnYes = {
                        text = "Đồng Ý",
                        onClick = function()
                                AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                                PopupManager:hide(Constant.PoppupID.Popup_Notification)
                            end
                    },
                    btnNo = {
                        disable = true
                    }
                })            
            else
                PopupManager:show(Constant.PoppupID.Popup_Notification, {
                    title = "THÔNG BÁO",
                    desrciption = resp.msg,
                    btnYes = {
                        text = "Đồng Ý",
                        onClick = function()
                                AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                                PopupManager:hide(Constant.PoppupID.Popup_Notification)
                            end
                    },
                    btnNo = {
                        disable = true
                    }
                })  
            end
        end)
    end)
end

function PopupExchange:Close()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    PopupManager:hide(self.PopupID)
end

_G.PopupExchange = PopupExchange
