Lib.CheckGlobal("Toat")

Toat = {}

function Toat:Show(text, option)
    PopupManager:show(option, {
        text = text
    })
end