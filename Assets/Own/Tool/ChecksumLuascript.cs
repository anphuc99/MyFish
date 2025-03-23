#if UNITY_EDITOR
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public class ChecksumLuascript : MonoBehaviour
{
    public string path;

    [Button]
    public void ExprotSHA256()
    {
        Debug.Log(AssetBundleManager.GenerateSHA256ChecksumForFile(Application.dataPath + "/../tool-build/build.lua"));
    }
    [Button]
    public void Encrypt()
    {
        byte[] key = { 36, 48, 43, 112, 101, 105, 67, 89, 75, 83, 79, 38, 85, 74, 81, 90, 89, 94, 120, 83, 98, 33, 65, 85, 106, 70, 51, 79, 101, 79, 77, 76 };
        byte[] iv = { 50, 135, 251, 183, 12, 14, 254, 193, 24, 121, 132, 152, 204, 141, 211, 119};

        string luaScript = File.ReadAllText(path);
        byte[] encrypt = EncryptionHelper.Encrypt(luaScript, key, iv);
        string base64 = Convert.ToBase64String(encrypt);
        File.WriteAllText(path, base64);
        Debug.Log("Encrypt success");
    }
    [Button]
    public void GenerateRandomPassword(int length)
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+";
        System.Random random = new System.Random();
        char[] password = new char[length];

        for (int i = 0; i < length; i++)
        {
            password[i] = chars[random.Next(chars.Length)];
        }

        byte[] bytes = Encoding.UTF8.GetBytes(password);

        string rs = "{";

        foreach (byte b in bytes)
        {
            rs += b.ToString() + ",";
        }
        rs += "}";
        Debug.Log(rs);
    }
    [Button]
    public void GenerateRandomIV()
    {
        byte[] iv = EncryptionHelper.GenerateRandomIV();
        string rs = "{";

        foreach (byte b in iv)
        {
            rs += b.ToString() + ",";
        }
        rs += "}";
        Debug.Log(rs);
    }
    [Button]
    public void ConvertStringToByte(string str)
    {
        byte[] bytes = Encoding.UTF8.GetBytes(str);
        string rs = "{";

        foreach (byte b in bytes)
        {
            rs += b.ToString() + ",";
        }
        rs += "}";
        Debug.Log(rs);
    }

    [Button]
    public void test()
    {
        byte[] bytes = { 91, 126, 69, 108, 87, 44, 75, 54, 81, 83, 90, 33, 53, 108, 39, 50, 83, 69, 91, 52, 114, 70, 57, 85, 49, 120, 122, 65, 86, 103, 91, 123 };
        string url = Encoding.UTF8.GetString(bytes);
        Debug.Log(url);
    }
}
#endif