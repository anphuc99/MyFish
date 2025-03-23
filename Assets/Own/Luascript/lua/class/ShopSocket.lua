---@class ShopSocket
local ShopSocket = class("ShopSocket")

function ShopSocket:GetFish(UUID)
    local query = { cmd = UUID and "get_other" or "get", UUID = UUID }
    ServerHandler:SendMessage(Enum.Socket.FISH_SHOP, query, function(resp)
        local inform = resp.data.list
        if resp.code == 1 then
            Me:InitShopFish(inform)
        end
    end)
end

function ShopSocket:GetDecoration()
    local query = { cmd = "get"}
    ServerHandler:SendMessage(Enum.Socket.DECORATION_SHOP, query, function(resp)
        local inform = resp.data.list
        if resp.code == 1 then
            Me:InitShopDecoration(inform)
        end
    end)
end

function ShopSocket:BuyFish(data, callback)
    local index=Me:getIndex()
    local query = {
        cmd = "buy",
		data = 
		{
			amount = 1,
			gender = data.gender,
			UID = data.UID,
			aquarium = index
		}
    }
    ServerHandler:SendMessage(Enum.Socket.FISH_SHOP, query, function(resp)
        if resp.code == 3 then
            local fishClass=Me:add_fish_by_id_index(resp.data,index)
            Event:Emit(Constant.Event.AddFish, resp.data.UID, fishClass)
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

        if callback then
            callback({ code = resp.code })
        end
    end)
end

function ShopSocket:BuyDecoration(data)
    local index = Me:getIndex()
    local query = {
        cmd = "buy",
        data = 
        {
            UID = data.UID,
            aquarium = index,
            pay = data.pay
        }
    }
    ServerHandler:SendMessage(Enum.Socket.DECORATION_SHOP, query, function(resp)
        if resp.code == 3 then
            Toat:Show(resp.msg, Constant.PoppupID.Popup_Toat)
            Event:Emit(Constant.Event.OnAddDecorItem, data.UID)
        else
            local msg
            if (resp.code == 4) then
                msg = "Đã mua đủ " .. tostring(Me:get_player():get().max_slot_decoration) .. " đồ trang trí!"
            else
                msg = resp.msg
            end
            PopupManager:show(Constant.PoppupID.Popup_Notification, {
                title = "THÔNG BÁO",
                desrciption = msg,
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

function ShopSocket:BuyStall(data)
    local query = {
        cmd = "buy",
        data =
        {
            UID = data.UID,
            amount = data.amount,
            pay = data.pay
        }
    }
    ServerHandler:SendMessage(Enum.Socket.ITEM_SHOP, query, function(resp)
        if resp.code == 3 then
            local msg = resp.msg .. " " .. resp.data.name
            Toat:Show(msg, Constant.PoppupID.Popup_Toat)
            for i = 1, data.amount, 1 do
                Event:Emit(Constant.Event.OnAddBagItem, resp.data.UID)
            end
    		PopupManager:hide(Constant.PoppupID.Popup_BuyAmount)
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

_G.ShopSocket = ShopSocket