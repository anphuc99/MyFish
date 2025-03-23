using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Networking;

public static class FirebaseKey
{
    public const string GameStatus = "GameStatus";
    public const string AccountURL = "AccountURL";
    public const string ChecksumURLAndroidDev = "ChecksumURLAndroidDev";
    public const string ChecksumURLAndroidRelease = "ChecksumURLAndroidRelease";
    public const string ChecksumURLIOSDev = "ChecksumURLIOSDev";
    public const string ChecksumURLIOSRelease = "ChecksumURLIOSRelease";
    public const string URLRegister = "URLRegister";
    public const string LuaPathDev = "LuaPathDev";
    public const string LuaPathRelease = "LuaPathRelease";
    public const string LuaCheckSum = "LuaCheckSum";
}

public class RemoteConfigManager : MonoBehaviour
{
    public static Dictionary<string, string> configData = new Dictionary<string, string>();
    public static bool remoteLoadDone;
    private void Start()
    {

#if UNTY_BUILD_RELEASE
        StartCoroutine(FetchConfigValues());
#else
        RemoteConfigTool remoteConfigTool = RemoteConfigTool.Instance;
        foreach(var configData in remoteConfigTool.data)
        {
            SetDefaultData(configData.Key, configData.Value);
        }
        remoteLoadDone = true;
#endif
        DontDestroyOnLoad(gameObject);
    }
    private IEnumerator FetchConfigValues()
    {

#if!UNTY_BUILD_RELEASE
        int[] enbytes = { 1 };
#endif

#if UNITY_RELEASE
        int[] enbytes = { 104, 116, 116, 112, 115, 58, 47, 47, 97, 115, 115, 101, 116, 46, 111, 104, 103, 97, 109, 101, 46, 105, 111, 46, 118, 110, 47, 97, 115, 115, 101, 116, 47, 82, 101, 108, 101, 97, 115, 101, 47, 114, 101, 109, 111, 116, 101, 67, 111, 110, 102, 105, 103, 46, 106, 115, 111, 110 };
#elif UNITY_DEVELOPMENT
        int[] enbytes = { 104, 116, 116, 112, 115, 58, 47, 47, 97, 115, 115, 101, 116, 46, 111, 104, 103, 97, 109, 101, 46, 105, 111, 46, 118, 110, 47, 97, 115, 115, 101, 116, 47, 68, 101, 118, 47, 114, 101, 109, 111, 116, 101, 67, 111, 110, 102, 105, 103, 46, 106, 115, 111, 110 };
#endif
        byte[] bytes = new byte[enbytes.Length];
        for (int i = 0; i < enbytes.Length; i++)
        {
            bytes[i] = Convert.ToByte(enbytes[i]);
        }
        string url = Encoding.UTF8.GetString(bytes);
        using (UnityWebRequest webRequest = UnityWebRequest.Get(url))
        {
            yield return webRequest.SendWebRequest();
            if (webRequest.result == UnityWebRequest.Result.Success)
            {
                int[] enkey = { 91, 126, 69, 108, 87, 44, 75, 54, 81, 83, 90, 33, 53, 108, 39, 50, 83, 69, 91, 52, 114, 70, 57, 85, 49, 120, 122, 65, 86, 103, 91, 123 };
                byte[] key = new byte[enkey.Length];
                for (int i = 0; i < enkey.Length; i++)
                {
                    key[i] = Convert.ToByte(enkey[i]);
                }
                byte[] IV = { 143, 133, 189, 3, 169, 20, 86, 254, 124, 89, 127, 105, 170, 175, 145, 52 };
                string text = webRequest.downloadHandler.text;
                byte[] b = Convert.FromBase64String(text);
                string data = EncryptionHelper.Decrypt(b,key,IV);
                JObject remoteData = JObject.Parse(data);
                foreach (var property in remoteData.Properties())
                {
                    configData.Add(property.Name, property.Value.ToObject<string>());
                }

                if (configData["GameVersion"] == Application.version)
                {
                    remoteLoadDone = true;
                }
                else
                {
                    SceneLoader.Instance.ShowPopup("Đã có phiên bản mới vui lòng cập nhật!", () =>
                    {
                        SceneLoader.Instance.HidePopup();
                    }, () =>
                    {
                        Application.Quit();
                    });
                }
            }
            else
            {
                SceneLoader.Instance.ShowPopup("Lỗi kết nối với máy chủ vui lòng kiểm tra đường truyền!", ()=>
                {
                    SceneLoader.Instance.HidePopup();
                    LeanTween.delayedCall(2, () =>
                    {
                        Start();
                    });
                }, () =>
                {
                    Application.Quit();
                });
            }
        }
    }

    public static string GetValue(string key)
    {
        if (configData.ContainsKey(key))
        {
            return configData[key];
        }
        throw new Exception($"key {key} does not exist");
    }

    public static void SetDefaultData(string key, string value)
    {
        if (!configData.ContainsKey(key))
        {
            configData.Add(key, value);
        }
    }
}