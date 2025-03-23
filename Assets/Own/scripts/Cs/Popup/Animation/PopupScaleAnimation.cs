using DevMini.Plugin.Popup;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopupScaleAnimation : MonoBehaviour, IPopupAnimation
{
    public LeanTweenType ease = LeanTweenType.easeInOutElastic;
    public float time = 0.2f;
    public void OnShow(GameObject view, Action onComplete)
    {
        view.transform.localScale = Vector3.zero;
        LeanTween.scale(view, Vector3.one, time).setEase(ease).setOnComplete(onComplete);
    }

    public void OnHide(GameObject view, Action onComplete)
    {
        LeanTween.scale(view, Vector3.zero, time).setOnComplete(onComplete);
    }

}
