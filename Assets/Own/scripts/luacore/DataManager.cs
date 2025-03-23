using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using static UnityEngine.UI.Image;


public class DataManager
{
    public static DataManager Instance => _ins;
    private static DataManager _ins;

    private static Dictionary<string, string> cache = new Dictionary<string, string>();

    private string _dataFile = "/data.db";
    private string _ivFile = "/IV.bytes";
    public DataManager() 
    {
        _ins = this;
        Load();
    }

    public void Load()
    {
        string filePath = Application.persistentDataPath + _dataFile;
        string ivPath = Application.persistentDataPath + _ivFile;
        if (File.Exists(filePath))
        {
            // Khóa AES và IV. Đảm bảo rằng đây là cùng một Key và IV đã được sử dụng để mã hóa.
            byte[] Key = Encoding.UTF8.GetBytes("x@+Rt@z7K_oRwt]k{4+E]gI~TNI[iGa4");
            byte[] IV = File.ReadAllBytes(ivPath);

            try
            {
                // Đọc dữ liệu đã mã hóa từ file
                byte[] cipherText = File.ReadAllBytes(filePath);

                // Giải mã dữ liệu
                string decryptedText = EncryptionHelper.Decrypt(cipherText, Key, IV);
                DynValue table = DynValue.NewTable(LuaCore.JsonDecode(decryptedText));
                LuaCore.GetGlobal("DataLocalManager").Table.Set("data", table);

            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }

        }
        else
        {
            DynValue table = DynValue.NewTable(LuaCore.CreateTable());
            LuaCore.GetGlobal("DataLocalManager").Table.Set("data", table);
        }
    }


    public void Save()
    {
        string data = LuaCore.JsonEncode(LuaCore.GetGlobal("DataLocalManager").Table.Get("data").Table);
        string dataPath = Application.persistentDataPath + _dataFile; 
        string ivPath = Application.persistentDataPath + _ivFile; 

        // Chuyển đổi chuỗi thành mảng byte
        byte[] Key = Encoding.UTF8.GetBytes("x@+Rt@z7K_oRwt]k{4+E]gI~TNI[iGa4");
        byte[] IV = EncryptionHelper.GenerateRandomIV();                

        try
        {
            byte[] encrypted = EncryptionHelper.Encrypt(data, Key, IV);
            // Lưu mảng byte vào file
            File.WriteAllBytes(dataPath, encrypted);
            File.WriteAllBytes(ivPath, IV);

            Debug.Log("Data has been saved successfully.");
        }
        catch (Exception e)
        {
            Debug.LogException(e);
        }
    }

    public static void SetCache(string key, Table value)
    {
        cache[key] = LuaCore.JsonEncode(value);
    }

    public static Table GetCache(string key)
    {
        if (cache.ContainsKey(key))
        {
            return LuaCore.JsonDecode(cache[key]);
        }
        return null;
    }
}
