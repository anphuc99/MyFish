using DevMini.Plugin.Popup;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopupToatAnimation : MonoBehaviour, IPopupAnimation
{
    public float time;
    public LeanTweenType ease;
    public GameObject toatObject;

    public void OnShow(GameObject view, Action onComplete)
    {
        CanvasGroup canvasGroup = view.GetComponent<CanvasGroup>();
        canvasGroup.alpha = 1;
        ((RectTransform)toatObject.transform).anchoredPosition = Vector2.zero;
        LeanTween.value(view, 0, 2, time).setEase(ease).setOnUpdate((float value) =>
        {
            ((RectTransform)toatObject.transform).anchoredPosition += new Vector2(0, value);
        }).setOnComplete(onComplete);
        LeanTween.value(view, 1, 0, time).setEase(ease).setOnUpdate((float value) =>
        {
            canvasGroup.alpha = value;
        });
    }
    public void OnHide(GameObject view, Action onComplete)
    {        
        onComplete?.Invoke();
    }
}
