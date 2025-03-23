#if UNITY_EDITOR
using Newtonsoft.Json.Linq;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

[Serializable]
public class KeyValue
{
    public string Key;
    public string Value;
}

public class RemoteConfigTool : MonoBehaviour
{
    public static RemoteConfigTool Instance
    {
        get
        {
            if (_ins == null)
            {
                var guidPopup = AssetDatabase.FindAssets("RemoteConfig t:Prefab", null);
                foreach (var guid in guidPopup)
                {
                    var remotePath = AssetDatabase.GUIDToAssetPath(guid);
                    var remoteConfigTool = AssetDatabase.LoadAssetAtPath<RemoteConfigTool>(remotePath);
                    if (remoteConfigTool != null)
                    {
                        _ins = remoteConfigTool;
                    }
                }
            }
            return _ins;
            
        }
    }

    private static RemoteConfigTool _ins;

    public string path;    
    
    public List<KeyValue> data;

    [Button]
    public void Convert()
    {
        byte[] key = { 91, 126, 69, 108, 87, 44, 75, 54, 81, 83, 90, 33, 53, 108, 39, 50, 83, 69, 91, 52, 114, 70, 57, 85, 49, 120, 122, 65, 86, 103, 91, 123 };
        byte[] IV = { 143, 133, 189, 3, 169, 20, 86, 254, 124, 89, 127, 105, 170, 175, 145, 52 };
        string json = ConvertToJson();
        byte[] encrypt = EncryptionHelper.Encrypt(json, key, IV);
        string base64 = System.Convert.ToBase64String(encrypt);
        File.WriteAllText(path, base64);
        Debug.Log("Encrypt Remote Config success");
    }

    private string ConvertToJson()
    {
        JObject jobject = new JObject();
        foreach (KeyValue kv in data)
        {
            jobject[kv.Key] = kv.Value;
        }
        return jobject.ToString();
    }

    public void AddKey(string key, string value)
    {
        foreach(KeyValue kv in data)
        {
            if(kv.Key == key)
            {
                kv.Value = value;
                return;
            }
        }
        data.Add(new KeyValue()
        {
            Key = key,
            Value = value
        });
    }
}
#endif