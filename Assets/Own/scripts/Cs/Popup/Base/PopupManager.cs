using MoonSharp.Interpreter;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace DevMini.Plugin.Popup
{
    public class PopupManager : MonoBehaviour
    {
        public static PopupManager Instance => _ins;
        private static PopupManager _ins;
        public GameObject lockUI;
        public GameObject lockWorldClick;
        public Canvas canvas;
        public List<PopupController> _listPopup = new List<PopupController>();
        public List<PopupController> _listLuaPopup = new List<PopupController>();

        private Dictionary<string, PopupController> _popuController;
        private int _countPopupShow;
        private void Awake()
        {
            _ins = this;
            EventManager.onLuaScriptLoadDone += StartPopupLua;
            EventManager.onLogout += OnReload;
            EventManager.onReLoad += OnReload;
        }

        private void OnDestroy()
        {
            EventManager.onLuaScriptLoadDone -= StartPopupLua;
            EventManager.onLogout -= OnReload;
            EventManager.onReLoad -= OnReload;
        }
#if !UNTY_BUILD_RELEASE
        [Button]
        public void UpdatePopup()
        {
            var guidPopup = AssetDatabase.FindAssets("t:Prefab", null);
            _listPopup = new List<PopupController>();
            _listLuaPopup = new List<PopupController>();
            for (int i = 0; i < guidPopup.Length; i++) 
            {
                var path = AssetDatabase.GUIDToAssetPath(guidPopup[i]);
                var popup = AssetDatabase.LoadAssetAtPath<PopupController>(path);
                if (popup != null)
                {
                    if (!popup.IsDisable)
                    {
                        LuaScriptPopup luaScriptPopup = popup.GetComponent<LuaScriptPopup>();
                        if (luaScriptPopup != null)
                        {
                            _listLuaPopup.Add(popup);
                        }
                        else
                        {
                            _listPopup.Add(popup);
                        }
                    }
                }
            }
        }
        [Button]             
        public void TestPopup(string popupid)
        {
            ShowPopup(popupid);
        }
#endif

        private void Start()
        {
            _popuController = new Dictionary<string, PopupController>();
            for (int i = 0; i < _listPopup.Count; i++)
            {
                var popup = _listPopup[i];
                PopupController popupController = Instantiate(popup, canvas.transform);
                popupController.gameObject.SetActive(false);
                _popuController.Add(popupController.PopupID, popupController);
            }
        }

        private void StartPopupLua()
        {
            for (int i = 0; i < _listLuaPopup.Count; i++)
            {
                var popup = _listLuaPopup[i];
                PopupController popupController = Instantiate(popup, canvas.transform);
                popupController.transform.SetSiblingIndex(1);
                popupController.gameObject.SetActive(false);
                _popuController.Add(popupController.PopupID, popupController);
            }
        }
        
        public IPopupScript ShowPopup(string PopupID, params KeyValuePair<string, object>[] param)
        {            
            PopupController popupController = _popuController[PopupID];    
            if(!popupController.gameObject.activeSelf)
            {
                popupController.paramLua = null;
                popupController.param = param;
                popupController.transform.SetAsLastSibling();
                popupController.Show();
                _countPopupShow++;
                lockWorldClick.SetActive(true);
            }
            return popupController.popupScript;
        }

        public IPopupScript ShowPopup(string PopupID, DynValue param)
        {
            PopupController popupController = _popuController[PopupID];
            if (!popupController.gameObject.activeSelf)
            {
                popupController.param = null;
                popupController.paramLua = param;
                popupController.transform.SetAsLastSibling();
                popupController.Show();
                _countPopupShow++;
                lockWorldClick.SetActive(true);
            }
            return popupController.popupScript;
        }

        public void HidePopup(string PopupID)
        {
            if (_popuController.ContainsKey(PopupID))
            {
                PopupController popupController = _popuController[PopupID];
                popupController.Hide();
                _countPopupShow--;
                if(_countPopupShow == 0)
                {
                    lockWorldClick.SetActive(false);
                }
            }
        }

        public void HideAllPopup()
        {
            foreach(var popup in _popuController.Values)
            {
                if (popup.gameObject.activeSelf)
                {
                    popup.Hide();
                }
            }
            _countPopupShow = 0;
            lockWorldClick.SetActive(false);
        }

        public void OnReload()
        {
            HideAllPopup();
            foreach(var popup in _listLuaPopup)
            {
                if (_popuController.ContainsKey(popup.PopupID))
                {
                    Destroy(_popuController[popup.PopupID].gameObject);
                    _popuController.Remove(popup.PopupID);
                }
            }
        }

        public void LockUI(bool block)
        {
            lockUI.SetActive(block);
        }
    }
}
