using DevMini.Plugin.Popup;
using MoonSharp.Interpreter;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class PopupToat : MonoBehaviour, IPopupScript
{
    public string PopupID { get; set; }
    public Kvp[] param { get; set; }
    public DynValue paramLua { get; set; }

    public TextMeshProUGUI text;

    public void OnBeginShow()
    {
        if (param != null)
        {
            text.text = param.GetValue<string>("text");
        }
        else if (paramLua != null)
        {
            text.text = paramLua.Table.Get("text").String;
        }
    }

    public void OnBeginHide()
    {        
    }

    public void OnEndHide()
    {        
    }

    public void OnEndShow()
    {      
        PopupManager.Instance.HidePopup(PopupID);
    }
}
