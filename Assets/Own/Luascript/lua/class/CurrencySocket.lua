Lib.CheckGlobal("CurrencySocket")

CurrencySocket = {}

function CurrencySocket:GetCurrency(callback)
    local data = {
        cmd = "get"
    }

    ServerHandler:SendMessage(Enum.Socket.CURRENCY, data, function (resp)
        callback(resp)
    end)
end

function CurrencySocket:Exchange(currency, amount, callback)
    local data = {
        cmd = "exchange",
        data = {
            to_currency = currency,
            amount = amount
        }
    }
    ServerHandler:SendMessage(Enum.Socket.CURRENCY, data, function (resp)
        callback(resp)
    end)
end