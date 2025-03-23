using DevMini.Plugin.Popup;
using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[MoonSharpUserData]
public class APIPopupManager
{
    public static DynValue Show(string popupID, Table param)
    {
        IPopupScript popupScript = PopupManager.Instance.ShowPopup(popupID, DynValue.NewTable(param));
        if(popupScript is LuaScriptPopup popup)
        {
            return popup.luaObject;
        }
        return null;
    }

    public static void Hide(string popupID)
    {
        PopupManager.Instance.HidePopup(popupID);
    }

    public static void HideAllPopup()
    {
        PopupManager.Instance.HideAllPopup();
    }

    public static void LockUI(bool block)
    {
        PopupManager.Instance.LockUI(block);
    }
}
