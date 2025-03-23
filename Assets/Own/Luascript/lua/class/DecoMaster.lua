Lib.CheckGlobal("DecoMaster")
DecoMaster = {}

DecoMaster.List = {}  -- Initialize an empty table to store decoration data

-- Add or update decoration data
function DecoMaster.Update(_inform)
    if _inform.UUID and type(_inform) == "table" then
        DecoMaster.List[tostring(_inform.UUID)] = {} -- Store by UUID as a string key
        for k, v in pairs(_inform) do
            DecoMaster.List[tostring(_inform.UUID)][k] = v
        end
    end
end

-- Get decoration data by UUID
function DecoMaster.getByUID(UUID)
    return DecoMaster.List[tostring(UUID)] 
end

function DecoMaster.getBonusByUID(UUID)
    return DecoMaster.List[tostring(UUID)]["bonus"]
end

function DecoMaster.getOnServer(callback)
    MasterSocket:GetMaster(Enum.MASTER.DECORATION, function (resp)
        local inform = resp.data.list

        for k, v in pairs(inform) do
            DecoMaster.Update(v)
        end
        if callback then
            callback({code=resp.code,inform=inform})
        end
    end)
end
