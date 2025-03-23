using DevMini.Plugin.Popup;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class LoadPopupManager : MonoBehaviour
{
    private IEnumerator Start()
    {
        yield return new WaitUntil(()=> LoadAssetManager.isLoadAssetDone);
#if UNTY_BUILD_RELEASE
        GameObject popupManager = AssetBundleManager.Instance.GetAssetBundle("popup-manager").LoadAsset<GameObject>("popup-manager");
#else
        GameObject popupManager = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Prefabs/popup/popup-manager.prefab");
#endif
        DontDestroyOnLoad(Instantiate(popupManager));
    }
}
