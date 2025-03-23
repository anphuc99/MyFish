using DevMini.Plugin.Popup;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class SceneLoader : MonoBehaviour
{
    public static SceneLoader Instance {
        get 
        {
            return _instance;
        } 
    }

    public bool isLoading;
    public PopupController popupYesNo;
    public Canvas canvas;


    private static SceneLoader _instance;

    [SerializeField] private Slider _sliderLoader;
    [SerializeField] private TextMeshProUGUI textInfo;

    void Awake()
    {
        if (_instance == null)
        {
            _instance = this;
            DontDestroyOnLoad(gameObject);
            popupYesNo = Instantiate(popupYesNo, canvas.transform);
            popupYesNo.gameObject.SetActive(false);
            gameObject.SetActive(false);
        }
    }

    public void LoadScene(string name)
    {        
        isLoading = true;
        gameObject.SetActive(true);
        StartCoroutine(LoadSceneAsync(name));
    }

    public void LoadData()
    {
        if (!isLoading)
        {
            isLoading = true;            
            gameObject.SetActive(true);
            _sliderLoader.value = 0;
            textInfo.text = "";
        }
        
    }    

    public void SetValue(float value, bool isAnim = true)
    {
        if(isAnim)
        {
            LeanTween.cancel(gameObject);
            LeanTween.value(gameObject, _sliderLoader.value, Convert.ToInt32(value * 100), 0.5f).setOnUpdate((float v) =>
            {
                _sliderLoader.value = Convert.ToInt32(v);
            });
        }
        else
        {
            _sliderLoader.value = value;
        }
    }    

    public void SetTextInfo(string text)
    {
        textInfo.text = text;
    }

    IEnumerator LoadSceneAsync(string name)
    {
        // Bắt đầu quá trình load scene không đồng bộ
        AsyncOperation asyncOperation = SceneManager.LoadSceneAsync(name);
        float curProgress = _sliderLoader.value;
        // Cho đến khi scene được load hoàn toàn
        while (!asyncOperation.isDone)
        {
            // Lấy giá trị phần trăm đã tải
            float progress = Mathf.Clamp01(asyncOperation.progress / 0.9f); // 0.9f là giá trị tối đa của asyncOperation.progress

            // Hiển thị phần trăm đã tải
            if (_sliderLoader != null)
            {
                _sliderLoader.value = Convert.ToInt32(curProgress +(progress / (1 - curProgress)) * 100);
            }

            yield return null; // Chờ một frame
        }
        _sliderLoader.value = 0;
        gameObject.SetActive(false);
        isLoading = false;
    }

    public void ShowPopup(string desrciption, Action BtnYesClick, Action BtnNoClick, string btnYesText = "Xác nhận", string btnNoText = "Thoát")
    {
        popupYesNo.param = new Kvp[] { 
            new Kvp("desrciption", desrciption),
            new Kvp("btnYes", new Kvp[]
            {
                new Kvp("text", btnYesText),
                new Kvp("onClick",BtnYesClick)
            }),
            new Kvp("btnNo", new Kvp[]
            {
                new Kvp("text", btnNoText),
                new Kvp("onClick",BtnNoClick)
            })
        };
        popupYesNo.Show();
    }

    public void HidePopup()
    {
        popupYesNo.Hide();
    }
}
