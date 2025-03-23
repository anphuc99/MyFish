Lib.CheckGlobal("ItemSocket")

ItemSocket = {}

function ItemSocket:GetItem(callback)
    MasterSocket:GetMaster(Enum.MASTER.ITEM, function (resp)
        local inform = resp.data.list
        if resp.code == 1 then            
            Me:InitItem(inform)
        end
        if callback then
            callback()
        end
    end)
end