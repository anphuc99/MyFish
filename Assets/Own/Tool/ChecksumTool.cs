#if UNITY_EDITOR
using Newtonsoft.Json.Linq;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class ChecksumTool : MonoBehaviour
{
    [Serializable]
    public class AssetPath { public string name; public string path; }
    public string exportPath;
    public List<AssetPath> paths = new List<AssetPath>();

    [Button]
    private void ExportCheckSum()
    {
        JObject json = new JObject();

        json["Asset"] = new JObject();
        json["CheckSum"] = new JObject();

        foreach (var path in paths)
        {
            json["CheckSum"][path.name] = AssetBundleManager.GenerateSHA256ChecksumForFile(Application.dataPath + "\\..\\" + path.path);
            json["Asset"][path.name] = "https://asset.ohgame.io.vn/asset/Release/android/" + path.name;
        }

        File.WriteAllText(Application.dataPath + "\\..\\" + exportPath + "checksum.json", json.ToString());
        Debug.Log("Create check sum complete");
    }
}
#endif