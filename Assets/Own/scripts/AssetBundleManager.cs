using DevMini.Plugin.Popup;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;
[Serializable]
public class AssetWebservice
{
    public string name;
    public string url;
    public AssetBundle assetBundle;
}

public class AssetBundleManager : MonoBehaviour
{
    public static AssetBundleManager Instance;

#if !UNTY_BUILD_RELEASE
    public string checksumURL => "";
#else
#if UNITY_ANDROID
#if UNITY_DEVELOPMENT
    public string checksumURL => RemoteConfigManager.GetValue(FirebaseKey.ChecksumURLAndroidDev);
#elif UNITY_RELEASE
    public string checksumURL => RemoteConfigManager.GetValue(FirebaseKey.ChecksumURLAndroidRelease);
#endif
#elif UNITY_IOS
#if UNITY_DEVELOPMENT
    public string checksumURL => RemoteConfigManager.GetValue(FirebaseKey.ChecksumURLIOSDev);
#elif UNITY_RELEASE
    public string checksumURL => RemoteConfigManager.GetValue(FirebaseKey.ChecksumURLIOSRelease);
#endif
#endif
#endif

    [NonSerialized]
    public string assetPath;

    public List<AssetWebservice> assetbundlePaths;
    private JObject _dataCheckSum;
    

    private void Start()
    {
        Instance = this;
        assetPath = Application.persistentDataPath + "/AssetData/";
    }

    public IEnumerator LoadAsset(Action<int> process)
    {
        int asset = 0;
        foreach (var path in assetbundlePaths)
        {            
            yield return LoadSceneFromAssetBundle(path);
            asset++;
            process?.Invoke(Convert.ToInt32(((float)asset / (float)assetbundlePaths.Count) * 100));
        }
    }
    IEnumerator LoadSceneFromAssetBundle(AssetWebservice assetWebservice)
    {
        if (assetWebservice.assetBundle != null) yield break;
        string assetbundlePath = assetPath + assetWebservice.name;
        // Load the Asset Bundle
        AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(assetbundlePath);

        while (!request.isDone)
        {
            yield return null;
        }

        var assetBundle = request.assetBundle;

        if (assetBundle == null)
        {
            PopupManager.Instance.ShowPopup("Popup_YesNoSimple",
            new Kvp("desrciption", "Dữ liệu bị hỏng, bạn có muốn sửa lại?"),
            new Kvp("btnYes", new Kvp[]
            {
                new Kvp("text", "Xác nhận"),
                new Kvp("onClick",(Action)BtnYesClick)
            }),
            new Kvp("btnNo", new Kvp[]
            {
                new Kvp("text", "Thoát"),
                new Kvp("onClick",(Action)BtnNoClick)
            })
            );
            yield break;
        }   
        
        assetWebservice.assetBundle = assetBundle;
    }

    private void BtnYesClick()
    {
        PopupManager.Instance.HidePopup("Popup_YesNoSimple");
    }

    private void BtnNoClick()
    {
        PopupManager.Instance.HidePopup("Popup_YesNoSimple");
    }

    public IEnumerator DownRescource(Action<int> process)
    {
        yield return DownCheckSumFile();
        process?.Invoke(20);
        if (!Directory.Exists(assetPath))
        {
            Directory.CreateDirectory(assetPath);
        }

        int asset = 0;

        foreach(var wwwPath in assetbundlePaths)
        {
            if(!File.Exists(assetPath + wwwPath.name))
            {
                yield return DownloadFileCoroutine(wwwPath);
                asset++;
                process?.Invoke(Convert.ToInt32(20 + (((float)asset / (float)assetbundlePaths.Count) * 70)));
            }
            else
            {
                string checkSumRequest = CheckSumLocal(wwwPath);
                string checkSumResponse = CheckSumServer(wwwPath);
                if(checkSumRequest != checkSumResponse)
                {
                    yield return DownloadFileCoroutine(wwwPath);
                    asset++;
                    process?.Invoke(Convert.ToInt32(20 + (((float)asset / (float)assetbundlePaths.Count) * 70)));
                }
                else
                {
                    yield return null;
                    asset++;
                    process?.Invoke(Convert.ToInt32(20 + (((float)asset / (float)assetbundlePaths.Count) * 70)));
                }
            }
        }
    }

    public IEnumerator DownCheckSumFile()
    {
        if(_dataCheckSum == null)
        {
            bool isSuccess = false;
            string text = "";
            StoreManager.Instance.Read(checksumURL, (txt) =>
            {
                text = txt;
                isSuccess = true;
            });
            yield return new WaitUntil(() => isSuccess);

            
            _dataCheckSum = JObject.Parse(text);
            JObject asset = _dataCheckSum["Asset"].ToObject<JObject>();
            assetbundlePaths = new List<AssetWebservice>();
            foreach(var wwwPath in asset)
            {
                AssetWebservice assetWebservice = new AssetWebservice();
                assetWebservice.name = wwwPath.Key;
                assetWebservice.url = wwwPath.Value.ToObject<string>();
                assetbundlePaths.Add(assetWebservice);
            }
        }
    }

    IEnumerator DownloadFileCoroutine(AssetWebservice assetWebservice)
    {
        bool isSuccess = false;
        StoreManager.Instance.Download(assetWebservice.url, assetPath + assetWebservice.name, () => isSuccess = true);
        yield return new WaitUntil(() => isSuccess);
    }

    private string CheckSumLocal(AssetWebservice assetWebservice)
    {
        return GenerateSHA256ChecksumForFile(assetPath + assetWebservice.name);
    }

    private string CheckSumServer(AssetWebservice assetWebservice)
    {
        if(_dataCheckSum != null)
        {
            return _dataCheckSum["CheckSum"][assetWebservice.name].ToString();            
        }
        return null;
    }
    public static string GenerateSHA256ChecksumForFile(string filePath)
    {
        using (SHA256 sha256Hash = SHA256.Create())
        {
            // Đọc file vào một mảng byte
            byte[] fileBytes = File.ReadAllBytes(filePath);

            // Tính toán checksum
            byte[] hashBytes = sha256Hash.ComputeHash(fileBytes);

            // Chuyển mảng byte thành một chuỗi hex
            StringBuilder builder = new StringBuilder();
            foreach (byte b in hashBytes)
            {
                builder.Append(b.ToString("x2"));
            }
            return builder.ToString();
        }
    }

    public AssetBundle GetAssetBundle(string name)
    {
        return assetbundlePaths.Find(x=>x.name == name).assetBundle;
    }
}
