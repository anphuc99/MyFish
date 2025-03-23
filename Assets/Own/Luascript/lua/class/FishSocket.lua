---@class FishSocket
local FishSocket = class("FishSocket")

function FishSocket:GetFishByIndex(index, UUID)
    local query = {
        cmd = UUID and "get_other" or "get",
        aquarium = index,
        UUID = UUID
    }
    ServerHandler:SendMessage(Enum.Socket.FISH_DATA, query, function(resp)
        local inform = resp.data.list

        for _, value in ipairs(inform) do
            Me:InitAddFishByAquarium(index, value)
        end
    end)
end

function FishSocket:SellFish(fish)
    local packet = {
        cmd = "sell",
        data = {
            id = fish.id,
        }
    }

    local locate = fish.transform:GetPosition()
    ServerHandler:SendMessage(Enum.Socket.FISH_DATA, packet, function(resp)
        local desrciption
        if resp.code == 4 then
            fish:SellSelf()

            DropUpManager:CreateFlyItem(Enum.Aquarium.COIN_ID, nil, resp.resp.coin, locate)
            DropUpManager:CreateFlyItem(Enum.Aquarium.EXP_ID, nil, resp.resp.exp, locate)
            Me:remove_fish_by_id(fish.id)
            desrciption = resp.msg .. "!\n" .. "Nhận: " .. resp.resp.exp .. " exp"
            Event:Emit(Constant.Event.UpdateFishCount)
        else
            desrciption = resp.msg
        end

        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = desrciption,
            btnYes = {
                text = "Xác nhận",
                onClick = function()
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                end
            },
            btnNo = {
                disable = true
            }
        })
    end)
end

function FishSocket:SellFishPacket(fishpk)
    local fid = {}
    for k, v in pairs(fishpk) do
        table.insert(fid, v.id)
    end

    local packet = {
        cmd = "sell",
        data = {
            id = fid
        }
    }
    ServerHandler:SendMessage(Enum.Socket.FISH_DATA, packet, function(resp)
        local desc
        if resp.code == 4 then
            for k, fish in pair(fishpk) do
                fish:SellSelf()
                local locate = fish.transform:GetPosition()
                DropUpManager:CreateFlyItem(Enum.Aquarium.COIN_ID, nil, resp.resp.coin, locate)
                DropUpManager:CreateFlyItem(Enum.Aquarium.EXP_ID, nil, resp.resp.exp, locate)
                Me:remove_fish_by_id(fish.id)
            end
            Event:Emit(Constant.Event.UpdateFishCount)
            desc = resp.msg .. "!\n" .. "Nhận: " .. resp.resp.exp .. " exp"
        else
            desc = resp.msg
        end

        PopupManager:show(Constant.PoppupID.Popup_Notification, {
            title = "THÔNG BÁO",
            desrciption = desc,
            btnYes = {
                text = "Xác nhận",
                onClick = function()
                    AudioManager.Instance:PlaySoundEffect(Constant.SoundEffect.Button)
                    PopupManager:hide(Constant.PoppupID.Popup_Notification)
                end
            },
            btnNo = {
                disable = true
            }
        })
    end)
end

function FishSocket:SellFishPacket1(fishpk)
    local coin, exp = 0, 0
    local desrciption
    local count, cntok = 0, 0
    for k, fish in pairs(fishpk) do
        local packet = {
            cmd = "sell",
            data = {
                id = fish.id,
            }
        }
        local locate = fish.transform:GetPosition()
        ServerHandler:SendMessage(Enum.Socket.FISH_DATA, packet, function(resp)
            count = count + 1
            if resp.code == 4 then
                cntok = cntok + 1
                fish:SellSelf()

                DropUpManager:CreateFlyItem(Enum.Aquarium.COIN_ID, nil, resp.resp.coin, locate)
                DropUpManager:CreateFlyItem(Enum.Aquarium.EXP_ID, nil, resp.resp.exp, locate)
                Me:remove_fish_by_id(fish.id)
                coin = coin + resp.resp.coin
                exp = exp + resp.resp.exp
                Event:Emit(Constant.Event.UpdateFishCount)
            end
            if count == #fishpk then
                desrciption = "Bán thành công " .. cntok .. " con cá\n" .. "Nhận: " .. exp .. " exp\n" .. coin .. "coin"
                PopupManager:show(Constant.PoppupID.Popup_Notification, {
                    title = "THÔNG BÁO",
                    desrciption = desrciption,
                    btnYes = {
                        text = "Xác nhận",
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
end

_G.FishSocket = FishSocket
