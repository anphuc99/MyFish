using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEditor;
using UnityEngine;

public class LoadAssetManager : MonoBehaviour
{
    public static bool isLoadAssetDone;
    private IEnumerator Start()
    {
        SceneLoader.Instance.LoadData();
        yield return new WaitUntil(()=> SceneLoader.Instance != null);
        yield return new WaitUntil(() => AssetBundleManager.Instance != null);
        yield return new WaitUntil(() => RemoteConfigManager.remoteLoadDone);
        SceneLoader.Instance.SetTextInfo("Đang tải dữ liệu 0%");
#if UNTY_BUILD_RELEASE
        yield return LoadAssetBundle();
        isLoadAssetDone = true;
#else
        SceneLoader.Instance.LoadScene(Constant.Scene.Login);
        isLoadAssetDone = true;
#endif
    }

    private IEnumerator LoadAssetBundle()
    {
        int _process = 0;
        bool _success = false;
        yield return AssetBundleManager.Instance.DownRescource((process) =>
        {
            LeanTween.cancel(gameObject, false);
            LeanTween.value(gameObject,_process, process, 0.1f).setOnUpdate((float value) =>
            {
                _process = Convert.ToInt32(value);
                SceneLoader.Instance.SetTextInfo($"Đang tải dữ liệu {_process}%");
            }).setOnComplete(() => _success = true);
        });
        yield return new WaitUntil( () => _success);
        SceneLoader.Instance.SetTextInfo("Đang tải trò chơi 0%");
        yield return AssetBundleManager.Instance.LoadAsset((process) => {
            SceneLoader.Instance.SetValue(process / 100);
            SceneLoader.Instance.SetTextInfo($"Đang tải trò chơi {process}%");
        });
        SceneLoader.Instance.SetTextInfo($"Đang tải trò chơi 100%");
        SceneLoader.Instance.LoadScene(Constant.Scene.Login);
    }
}
