Lib.CheckGlobal("BreedSocket")
BreedSocket = {}

function BreedSocket:OnBreed(femaleId, maleId, listMaterial, callback)
    local data = {
        cmd = "breed",
        femaleId = femaleId,
        maleId = maleId,
        list = listMaterial
    }
    ServerHandler:SendMessage(Enum.Socket.BREED, data, callback)
end