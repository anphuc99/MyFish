---@class PopupPurchase : MonoBehaviour
local PopupPurchase = class("PopupPurchase", MonoBehaviour)
PopupPurchase.__path = __path

function PopupPurchase:buy20K()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    InAppPurchase:InitiatePurchase(Constant.IAP.GPoint20K, Lib.handler(self, self.Success), Lib.handler(self, self.Fail))    
end

function PopupPurchase:buy50K()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    InAppPurchase:InitiatePurchase(Constant.IAP.GPoint50K, Lib.handler(self, self.Success), Lib.handler(self, self.Fail))    
end
function PopupPurchase:buy100K()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    InAppPurchase:InitiatePurchase(Constant.IAP.GPoint100K, Lib.handler(self, self.Success), Lib.handler(self, self.Fail))    
end
function PopupPurchase:buy200K()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    InAppPurchase:InitiatePurchase(Constant.IAP.GPoint200K, Lib.handler(self, self.Success), Lib.handler(self, self.Fail))    
end
function PopupPurchase:buy500K()
    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
    InAppPurchase:InitiatePurchase(Constant.IAP.GPoint500K, Lib.handler(self, self.Success), Lib.handler(self, self.Fail))    
end


function PopupPurchase:Success(product)
    print("Buy success")
    local data = {
        invoice = product
    }
    ServerHandler:SendHTTP("/user/IAP", data, function (resp)
        resp = Json.decode(resp)
        if resp.status == 0 then
            PopupManager:show(Constant.PoppupID.Popup_Notification,{
                title = "THÔNG BÁO",
                        desrciption = "Nạp thành công! Vui lòng kiểm tra thư!",
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
            self:Fail(product)            
        end
    end)
end

function PopupPurchase:Fail(product)
    print("Buy fail")
    PopupManager:show(Constant.PoppupID.Popup_Notification,{
        title = "THÔNG BÁO",
                desrciption = "Nạp thất bại!",
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


function PopupPurchase:Close()
    PopupManager:hide(self.PopupID)
end
_G.PopupPurchase = PopupPurchase
