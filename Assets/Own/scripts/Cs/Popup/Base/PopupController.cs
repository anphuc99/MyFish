using MoonSharp.Interpreter;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
namespace DevMini.Plugin.Popup
{
    public interface IPopupScript
    {
        public string PopupID { get; set; }
        public KeyValuePair<string, object>[] param { get; set; }
        public DynValue paramLua { get; set; }
        public void OnBeginShow();
        public void OnEndShow();
        public void OnBeginHide();
        public void OnEndHide();

    }

    public class PopupController : MonoBehaviour
    {
        public string PopupID = "Popup_";
        public bool IsDisable;
        [SerializeField]
        private Image _blur;
        [SerializeField]
        private GameObject _view;
        public IPopupAnimation popupAnimation;
        public bool settingBackground;
        [ShowIf("settingBackground", true)]
        public Color backgroundBeginColor = Color.clear;
        [ShowIf("settingBackground", true)]
        public Color backgroundEndColor = new Color(0, 0, 0, 170f / 255f);
        [ShowIf("settingBackground", true)]
        public float timeChange = 0.1f;
        [ShowIf("settingBackground", true)]
        public LeanTweenType ease = LeanTweenType.easeInSine;

        public KeyValuePair<string, object>[] param;
        public DynValue paramLua;
        public IPopupScript popupScript;

        private void Awake()
        {
            popupScript = GetComponent<IPopupScript>();
            popupAnimation = GetComponent<IPopupAnimation>();
            popupScript.PopupID = PopupID;
        }

        public void Show()
        {
            gameObject.SetActive(true);
            if(_blur != null)
            {
                _blur.gameObject.SetActive(true);
                _blur.color = backgroundBeginColor;
            }
            LeanTween.value(gameObject, backgroundBeginColor, backgroundEndColor, timeChange)
                .setEase(ease)
                .setOnUpdate((Color color) =>
                {
                    if(_blur != null)
                    {
                        _blur.color = color;
                    }
                });
            popupScript.param = param;
            popupScript.paramLua = paramLua;
            if (popupAnimation != null)
            {
                gameObject.SetActive(true);
                popupScript.OnBeginShow();
                popupAnimation.OnShow(_view, popupScript.OnEndShow);
            }
            else
            {
                gameObject.SetActive(true);
                popupScript.OnBeginShow();
                popupScript.OnEndShow();
            }
        }

        public void Hide()
        {
            if (popupAnimation != null)
            {
                popupScript.OnBeginHide();
                popupAnimation.OnHide(_view, () =>
                {
                    popupScript.OnEndHide();
                    gameObject.SetActive(false);
                    if(_blur != null)
                    {
                        _blur.gameObject.SetActive(false);
                    }
                    gameObject.SetActive(false);
                });
            }
            else
            {
                popupScript.OnBeginHide();
                popupScript.OnEndHide();
                gameObject.SetActive(false);
                if (_blur != null)
                {
                    _blur.gameObject.SetActive(false);
                }
                gameObject.SetActive(false);
            }
        }
    }

}
