using MoonSharp.Interpreter;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Text;
using UnityEngine;
public class DataCsManager
    {
        public static DataCsManager Instance
        {
            get
            {
                if (_ins == null)
                {
                    _ins = Load();
                }
                return _ins;
            }
        }
        private static DataCsManager _ins;


        public LoginSend loginData;
        public string server;
        public string token;

        public static DataCsManager Load()
        {
            string _dataFile = "/data2.db";
            string _ivFile = "/IV2.bytes";
            string filePath = Application.persistentDataPath + _dataFile;
            string ivPath = Application.persistentDataPath + _ivFile;
            if (File.Exists(filePath))
            {
                // Khóa AES và IV. Đảm bảo rằng đây là cùng một Key và IV đã được sử dụng để mã hóa.
                byte[] Key = Encoding.UTF8.GetBytes("Kv3F!yEJ_z&d-MVy;JKVOz.sHow!qSE-");
                byte[] IV = File.ReadAllBytes(ivPath);

                try
                {
                    // Đọc dữ liệu đã mã hóa từ file
                    byte[] cipherText = File.ReadAllBytes(filePath);

                    // Giải mã dữ liệu
                    string decryptedText = EncryptionHelper.Decrypt(cipherText, Key, IV);
                    DataCsManager data = JsonConvert.DeserializeObject<DataCsManager>(decryptedText);
                    return data;
                }
                catch (Exception e)
                {
                    Debug.LogException(e);
                    throw e;
                }

            }
            else
            {
                return new DataCsManager();
            }
        }

        public void Save()
        {
            string data = JsonConvert.SerializeObject(Instance);
            string _dataFile = "/data2.db";
            string _ivFile = "/IV2.bytes";
            string dataPath = Application.persistentDataPath + _dataFile;
            string ivPath = Application.persistentDataPath + _ivFile;

            // Chuyển đổi chuỗi thành mảng byte
            byte[] Key = Encoding.UTF8.GetBytes("Kv3F!yEJ_z&d-MVy;JKVOz.sHow!qSE-");
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
    }