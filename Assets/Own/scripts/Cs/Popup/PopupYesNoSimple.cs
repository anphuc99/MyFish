using DevMini.Plugin.Popup;
using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class PopupYesNoSimple : MonoBehaviour, IPopupScript
{
    public string PopupID { get; set; }
    public Kvp[] param { get; set; }
    public DynValue paramLua { get; set; }

    public TextMeshProUGUI textBtnYes;
    public TextMeshProUGUI textBtnNo;
    public Button BtnYes;
    public Button BtnNo;
    public TextMeshProUGUI Description;
    public TextMeshProUGUI Title;

    public void OnBeginShow()
    {
		BtnYes.onClick.RemoveAllListeners();
		BtnNo.onClick.RemoveAllListeners();

        if(param != null)
        {
            string title = param.GetValue<string>("title");
            string desrciption = param.GetValue<string>("desrciption");
            Kvp[] btnYesParam = param.GetValue<Kvp[]>("btnYes");
            Kvp[] btnNoParam = param.GetValue<Kvp[]>("btnNo");
            if(Description != null)
            {
                Description.text = desrciption;
            }
            if(Title != null)
            {
                Title.text = title;
            }
            if (btnYesParam != null)
            {
                SetButton(btnYesParam, BtnYes, textBtnYes);
            }
            if(btnNoParam != null)
            {
                SetButton(btnNoParam, BtnNo, textBtnNo);
            }
        }
        else if (paramLua != null)
        {
            string title = paramLua.Table.Get("title").String;
            string desrciption = paramLua.Table.Get("desrciption").String;
            Table btnYesParam = paramLua.Table.Get("btnYes").Table;
            Table btnNoParam = paramLua.Table.Get("btnNo").Table;
            if (Description != null)
            {
                Description.text = desrciption;
            }
            if (Title != null)
            {
                Title.text = title;
            }
            if (btnYesParam != null)
            {
                SetButton(btnYesParam, BtnYes, textBtnYes);
            }
            if (btnNoParam != null)
            {
                SetButton(btnNoParam, BtnNo, textBtnNo);
            }
        }

    }
    public void OnEndShow() { }
    public void OnBeginHide()
    {
        if(BtnYes != null)
        {
            BtnYes.onClick.RemoveAllListeners();
        }
        if(BtnNo != null)
        {
            BtnNo.onClick.RemoveAllListeners(); 
        }
    }
    public void OnEndHide(){}

    private void SetButton(Kvp[] param, Button button, TextMeshProUGUI btnText)
    {
        if(btnText != null)
        {
            string text = param.GetValue<string>("text");
            btnText.text = text;
        }
        if(button != null)
        {
            object onClick = param.GetValue<object>("onClick");
            Action actionOnClick = null;
            actionOnClick = (Action)onClick;
            bool disable = param.GetValue<bool>("disable");
            button.gameObject.SetActive(!disable);
            if(actionOnClick != null)
            {
                button.onClick.AddListener(new UnityEngine.Events.UnityAction(actionOnClick));
            }
        }
    }

    private void SetButton(Table param, Button button, TextMeshProUGUI btnText)
    {
        if (btnText != null)
        {
            string text = param.Get("text").String;
            btnText.text = text;
        }
        if (button != null)
        {
            var onClick = param.Get("onClick").Function;
            Action actionOnClick = null;
            actionOnClick = () => onClick.CallFunction();
            bool disable = param.Get("disable").Boolean;
            button.gameObject.SetActive(!disable);
            if (actionOnClick != null)
            {
                button.onClick.AddListener(new UnityEngine.Events.UnityAction(actionOnClick));
            }
        }
    }

}
