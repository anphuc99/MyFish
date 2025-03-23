---@class BagSocket
local BagSocket = class("BagSocket")

-- Lấy tất cả dữ liệu vật phẩm từ TÚI (Server)
function BagSocket:GetItem()
    local query =
    {
        cmd = "get"
    }
    ServerHandler:SendMessage(Enum.Socket.ITEM_DATA, query, function(resp)
        local inform = resp.data.bag
        if resp.code == 1 then
            Me:InitBagItem(inform)
        end
    end)
end

-- Sử dụng vật phẩm từ TÚI (Server)
function BagSocket:UseItem(UID)
    if Me:get_player():getEnergy() >= 100 and (UID == Constant.Energy.Energy1 or UID == Constant.Energy.Energy2) then
        Toat:Show("Năng lượng đã đầy", Constant.PoppupID.Popup_Toat)
    else
        self:SubmitUseItem(UID)
    end
end

-- Xác nhận sử dụng vật phẩm từ TÚI (Server)
function BagSocket:SubmitUseItem(UID)
    local query =
    {
        cmd = "use",
        data =
        {
            item = UID,
            data = {
                aquarium = DataLocalManager:GetValue(Constant.Data.curAquarium) or 1
            }
        }
    }

    ServerHandler:SendMessage(Enum.Socket.ITEM_DATA, query, function(resp)
        if resp.code == 1 then  
            Event:Emit(Constant.Event.OnSubtractBagItem, UID, resp)
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
end

_G.BagSocket = BagSocket