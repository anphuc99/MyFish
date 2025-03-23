using DevMini.Plugin.Popup;
using FSMC.Runtime;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class PopupNotication : FSMC_Behaviour
{
    public enum PopupNotify
    {
        Popup_Notification,
        Popup_YesNoSimple
    }
    public PopupNotify PopupID;
    public string Title;
    public string Description;
    [Header("Button Yes Info")]
    public bool ShowBtnYes = true;
    public string txtBtnYes = "Xác nhận";
    public bool btnYesHideOnClick = false;
    [Header("Button No Info")]
    public bool ShowBtnNo = true;
    public string txtBtnNo = "Từ chối";
    public bool btnNoHideOnClick = false;
    public override void StateInit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        
    }
    public override void OnStateEnter(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        PopupManager.Instance.ShowPopup(PopupID.ToString(),
            new Kvp("desrciption", Description),
            new Kvp("btnYes", new Kvp[]
            {
                new Kvp("disable", !ShowBtnYes),
                new Kvp("text", txtBtnYes),
                new Kvp("onClick",(Action)(() => {
                    executer.SetTrigger("btnYesOnClick");
                    if(btnYesHideOnClick)
                    {
                        PopupManager.Instance.HidePopup(PopupID.ToString());
                    }
                }))
            }),
            new Kvp("btnNo", new Kvp[]
            {
                new Kvp("disable", !ShowBtnNo),
                new Kvp("text", txtBtnNo),
                new Kvp("onClick",(Action)(() =>{
                    executer.SetTrigger("btnNoOnClick");
                    if(btnNoHideOnClick)
                    {
                        PopupManager.Instance.HidePopup(PopupID.ToString());
                    }
                }))
            })
            );
    }

    public override void OnStateExit(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        
    }

    public override void OnStateUpdate(FSMC_Controller stateMachine, FSMC_Executer executer)
    {
        
    }
}
