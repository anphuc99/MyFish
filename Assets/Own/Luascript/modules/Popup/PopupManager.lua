PopupManager = {}

function PopupManager:show(popupID, param)
    APIPopupManager.show(popupID, param)
end

function PopupManager:hide(popupID)
    APIPopupManager.hide(popupID)
end

function PopupManager:LockUI(lock)
    APIPopupManager.LockUI(lock)
end

function PopupManager:HideAllPopup()
    APIPopupManager.HideAllPopup()
end