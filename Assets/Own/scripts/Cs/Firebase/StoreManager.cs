using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading.Tasks;
using System.IO;
using System;
using UnityEngine.Networking;
using Newtonsoft.Json.Linq;
using Unity.VisualScripting;
public class StoreManager : MonoBehaviour
{
    public static StoreManager Instance;

    private void Awake()
    {
        Instance = this;
    }

    public void Download(string path, string localSave, Action onSuccess = null)
    {
        StartCoroutine(DownloadFile(path, localSave, onSuccess));
    }

    public IEnumerator DownloadFile(string url, string localSave, Action onSuccess)
    {
        while(true)
        {
            string localFilePath = Path.Combine(Application.persistentDataPath, localSave);
            using (UnityWebRequest webRequest = UnityWebRequest.Get(url))
            {
                yield return webRequest.SendWebRequest();
                if (webRequest.result == UnityWebRequest.Result.Success)
                {
                    File.WriteAllBytes(localFilePath, webRequest.downloadHandler.data);
                    onSuccess?.Invoke();
                    yield break;
                }
                else
                {
                    bool reload = false;
                    SceneLoader.Instance.ShowPopup("Lỗi kết nối với máy chủ vui lòng kiểm tra đường truyền!", () =>
                    {
                        SceneLoader.Instance.HidePopup();
                        LeanTween.delayedCall(2, () =>
                        {
                            reload = true;
                        });
                    }, () =>
                    {
                        Application.Quit();
                    });
                    yield return new WaitUntil(() => reload);
                }
            }
        }
    }

    public void Read(string path, Action<string> callback)
    {
        StartCoroutine(ReadFile(path, callback));
    }
    private IEnumerator ReadFile(string url, Action<string> callback)
    {
        while (true)
        {
            using (UnityWebRequest webRequest = UnityWebRequest.Get(url))
            {
                yield return webRequest.SendWebRequest();
                if(webRequest.result == UnityWebRequest.Result.Success)
                {
                    callback?.Invoke(webRequest.downloadHandler.text);
                    yield break;
                }
                else
                {
                    bool reload = false;
                    SceneLoader.Instance.ShowPopup("Lỗi kết nối với máy chủ vui lòng kiểm tra đường truyền!", () =>
                    {
                        SceneLoader.Instance.HidePopup();
                        LeanTween.delayedCall(2, () =>
                        {
                            reload = true;
                        });
                    }, () =>
                    {
                        Application.Quit();
                    });
                    yield return new WaitUntil(() => reload);
                }
            }
        }
    }
}
