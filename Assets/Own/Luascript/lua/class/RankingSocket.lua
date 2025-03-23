Lib.CheckGlobal("RankingSocket")

RankingSocket = {}

function RankingSocket:getRankLevel(callback)
    local data = {
        cmd = "get",
        data = {
            type = "level"
        }
    }
    ServerHandler:SendMessage(Enum.Socket.RANKING, data, callback)
end

function RankingSocket:getRankFishOpen(callback)
    local data = {
        cmd = "get",
        data = {
            type = "fish_open"
        }
    }
    ServerHandler:SendMessage(Enum.Socket.RANKING, data, callback)
end

function RankingSocket:getRankCoin(callback)
    local data = {
        cmd = "get",
        data = {
            type = "coin"
        }
    }
    ServerHandler:SendMessage(Enum.Socket.RANKING, data, callback)
end

function RankingSocket:getRankPoint(callback)
    local data = {
        cmd = "get",
        data = {
            type = "point"
        }
    }
    ServerHandler:SendMessage(Enum.Socket.RANKING, data, callback)
end