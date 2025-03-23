Lib.CheckGlobal("FishMaster")
FishMaster = {}

FishMaster.List={}

function FishMaster:Init()
    ServerHandler:On(Enum.Socket.CHANGE_SIGNAL.FISH, function (resp)        
        local classFish = Me:add_fish_by_id_index(resp, DataLocalManager:GetValue(Constant.Data.curAquarium) or 1)
        Event:Emit(Constant.Event.AddFish, classFish.UID, classFish)
        Event:Emit(Constant.Event.UpdateFishCount)
    end)
end

-- Thêm Fish Master vào List
function  FishMaster:Update(_inform)
   
    if _inform.UID and type(_inform)=="table" then
        self.List[tostring(_inform.UID)]={}
        for k,v in pairs(_inform) do 
            self.List[tostring(_inform.UID)][k]=v
        end
    end
end

-- Lấy dữ liệu cá từ UID
function FishMaster:getByUID(UID)
   
    return self.List[tostring(UID)]
end

function FishMaster:setKey(UID, key,value)
    if not self.List[tostring(UID)] then
        return false
    end
    if not self.List[tostring(UID)].data then
        self.List[tostring(UID)].data={}
    end
    self.List[tostring(UID)].data[key]=value
    return true
end

function FishMaster:getKey(UID, key)
    if not self.List[tostring(UID)] then
        return nil
    end
    if not self.List[tostring(UID)].data then
        return nil
    end
    return self.List[tostring(UID)].data[key]
end
-- Hàm lọc master data theo key
function FishMaster:getAllByKey(key)
    local rs={}
    for k,v in pairs(self.List) do
        if v.data and v.data[key] then
           rs[tostring(k)]=v
        end
    end
    return rs
end
--Hàm lọc master data theo key và value
function FishMaster:getAllByKeyValue(key,value)
    local rs={}
    for k,v in pairs(self.List) do
        if v.data and v.data[key] and v.data[key]==value then
           rs[tostring(k)]=v
        end
    end
    return rs
end
--Update cá từ server về và callback
function FishMaster:getOnServer(callback)
    MasterSocket:GetMaster(Enum.MASTER.FISH, function (resp)
		local inform=resp.data.list
     
        for k,v in pairs(inform) do
            self:Update(v)
        end
        if callback then
            callback({code=resp.code,inform=inform})
        end
	end)
end
function FishMaster:getShopOnServer(callback)
    local packet =
	{
		cmd = "get",
	}
    ServerHandler:SendMessage(Enum.Socket.FISH_SHOP, packet, function (resp)
		local inform=resp.data.list
        for k,v in pairs(inform) do
            
            self:Update(v)
            self:setKey(v.UID,"shop",true)
        end
        if callback then
            callback({code=resp.code,inform=inform})
        end
        
	end)
end
