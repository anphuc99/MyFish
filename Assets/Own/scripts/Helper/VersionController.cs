using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;


public class VersionController : MonoBehaviour
{
    public TextMeshProUGUI versionText;
    void Start()
    {
        // Lấy số phiên bản
        string version = Application.version;
        if(AssetBundleVersion.Instance != null)
        {
            versionText.text = "Version: " + version + " " + AssetBundleVersion.Instance.version;
        }
        else
        {
            versionText.text = "Version: " + version;
        }

    }
}