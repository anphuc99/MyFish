using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;

public class BuildTool
{
    public class AssetPath { public string name; public string path; }
    [MenuItem("Tools/Build Asset/Android/Release")]
    public static async void BuildReleaseAndroid()
    {
        string assetBundleDirectory = "/../AssetBundles/Android";
        var assetPath = await BuildAssetBundle(assetBundleDirectory, BuildTarget.Android);
        string batchFilePath = Application.dataPath + "/../tool-build/";
        ExportCheckSum(assetPath, assetBundleDirectory, "Android", "Release");
        MoveAssetToAsset(assetPath, assetBundleDirectory, "Android", "Release");
        CopyFileLuaToTool();
        await RunTool(batchFilePath);
        MoveLuaToAsset(batchFilePath, "Release");
        CompileRemoteConfig("Release");
        EditorUtility.RevealInFinder(Application.dataPath + "/../asset-services/");
    }
    [MenuItem("Tools/Build Asset/Android/Dev")]
    public static async void BuildDevAndroid()
    {
        string assetBundleDirectory = "/../AssetBundles/Android";
        var assetPath = await BuildAssetBundle(assetBundleDirectory, BuildTarget.Android);
        string batchFilePath = Application.dataPath + "/../tool-build/";
        ExportCheckSum(assetPath, assetBundleDirectory, "Android", "Dev");
        MoveAssetToAsset(assetPath, assetBundleDirectory, "Android", "Dev");
        CopyFileLuaToTool();
        await RunTool(batchFilePath);
        MoveLuaToAsset(batchFilePath, "Dev");
        CompileRemoteConfig("Dev");
        EditorUtility.RevealInFinder(Application.dataPath + "/../asset-services/");
    }
    [MenuItem("Tools/Build Asset/IOS/Release")]
    public static async void BuildReleaseIOS()
    {

    }
    [MenuItem("Tools/Build Asset/IOS/Dev")]
    public static async void BuildDevIOS()
    {

    }
    #region Build Asset
    public static async Task<List<AssetPath>> BuildAssetBundle(string assetBundleDirectory, BuildTarget buildTarget)
    {
        ClearAssetBundleDirectory(assetBundleDirectory);
        if (!System.IO.Directory.Exists(Application.dataPath + assetBundleDirectory))
        {
            System.IO.Directory.CreateDirectory(Application.dataPath + assetBundleDirectory);
        }
        AssetBundleManifest manifest = BuildPipeline.BuildAssetBundles(Application.dataPath + assetBundleDirectory,
                                        BuildAssetBundleOptions.ForceRebuildAssetBundle,
                                        buildTarget);
        while (BuildPipeline.isBuildingPlayer)
        {
            await Task.Yield();
        }

        return ExportAssetBundlePaths(assetBundleDirectory, manifest);

    }

    private static void ClearAssetBundleDirectory(string directory)
    {
        if (Directory.Exists(directory))
        {
            DirectoryInfo dirInfo = new DirectoryInfo(directory);
            foreach (FileInfo file in dirInfo.GetFiles())
            {
                file.Delete();
            }
            foreach (DirectoryInfo dir in dirInfo.GetDirectories())
            {
                dir.Delete(true);
            }
        }
    }

    private static List<AssetPath> ExportAssetBundlePaths(string directory, AssetBundleManifest manifest)
    {
        // Get all asset bundle names
        string[] assetBundles = manifest.GetAllAssetBundles();

        // List to hold the paths of the asset bundles
        List<AssetPath> assetBundlePaths = new List<AssetPath>();

        foreach (string assetBundle in assetBundles)
        {
            string path = Path.Combine(directory, assetBundle);
            assetBundlePaths.Add(new AssetPath()
            {
                name = assetBundle,
                path = path
            });
            UnityEngine.Debug.Log($"Asset Bundle Path: {path}");
        }

        return assetBundlePaths;
    }

    private static void ExportCheckSum(List<AssetPath> paths, string exportPath, string performent, string ReleaseOrDev)
    {
        JObject json = new JObject();

        json["Asset"] = new JObject();
        json["CheckSum"] = new JObject();

        foreach (var path in paths)
        {
            json["CheckSum"][path.name] = AssetBundleManager.GenerateSHA256ChecksumForFile(Application.dataPath + path.path);
            json["Asset"][path.name] = $"https://asset.ohgame.io.vn/asset/{ReleaseOrDev}/{performent}/" + path.name;
        }

        File.WriteAllTextAsync(Application.dataPath + exportPath + "/checksum.json", json.ToString());
        UnityEngine.Debug.Log("Create check sum complete");
    }

    private static void MoveAssetToAsset(List<AssetPath> assetPath, string exportPath, string performent, string ReleaseOrDev)
    {
        string AssetPath = Application.dataPath + "/../asset-services/asset/" + ReleaseOrDev + "/" + performent;
        if(!Directory.Exists(AssetPath))
        {
            Directory.CreateDirectory(AssetPath);
        }
        foreach(var path in assetPath)
        {
            if (File.Exists(AssetPath + "/" + path.name))
            {
                File.Delete(AssetPath + "/" + path.name);
            }
            File.Copy(Application.dataPath + path.path, AssetPath + "/" + path.name, true);
        }
        if (File.Exists(AssetPath + "/checksum.json"))
        {
            File.Delete(AssetPath + "/checksum.json");
        }
        File.Copy(Application.dataPath + exportPath + "/checksum.json", AssetPath + "/checksum.json");
        UnityEngine.Debug.Log("Move Success");
    }
    #endregion
    #region Build RemoteConfig
    private static void CompileRemoteConfig(string ReleaseOrDev)
    {
        string path = Application.dataPath + "/../asset-services/asset/" + ReleaseOrDev + "/";
        var guidPopup = AssetDatabase.FindAssets("RemoteConfig t:Prefab", null);
        foreach (var guid in guidPopup)
        {
            var remotePath = AssetDatabase.GUIDToAssetPath(guid);
            var remoteConfigTool = AssetDatabase.LoadAssetAtPath<RemoteConfigTool>(remotePath);
            if(remoteConfigTool != null)
            {
                remoteConfigTool.path = path + "remoteConfig.json";
                remoteConfigTool.Convert();                
            }
        }
    }
    #endregion
    #region Build Lua
    private static void CopyFileLuaToTool()
    {
        string sourceDirectory = Application.dataPath + "/Own/Luascript";
        string destinationDirectory = Application.dataPath + "/../tool-build/lua";
        CopyDirectory(sourceDirectory, destinationDirectory);
        UnityEngine.Debug.Log("Copy Lua Success");
    }

    private static void CopyDirectory(string sourceDir, string destinationDir)
    {
        // Get the subdirectories for the specified directory.
        DirectoryInfo dir = new DirectoryInfo(sourceDir);
        DirectoryInfo[] dirs = dir.GetDirectories();

        // If the destination directory doesn't exist, create it.
        if (!Directory.Exists(destinationDir))
        {
            Directory.CreateDirectory(destinationDir);
        }

        // Get the files in the directory and copy them to the new location.
        FileInfo[] files = dir.GetFiles();
        foreach (FileInfo file in files)
        {
            string temppath = Path.Combine(destinationDir, file.Name);
            file.CopyTo(temppath, true);
        }

        // Copy subdirectories and their contents to new location.
        foreach (DirectoryInfo subdir in dirs)
        {
            string temppath = Path.Combine(destinationDir, subdir.Name);
            CopyDirectory(subdir.FullName, temppath);
        }
    }
    [MenuItem("tools/test")]
    private static async Task RunTool(string batchFilePath)
    {        
        string luaFile = batchFilePath + "build.lua";
        if (File.Exists(luaFile))
        {
            File.Delete(luaFile);
        }
        EditorUtility.RevealInFinder(batchFilePath);
        while(!File.Exists(luaFile))
        {
            await Task.Yield();
        }

        EncryptLua(luaFile);
        CheckSumLua(luaFile);
    }

    private static void EncryptLua(string path)
    {
        byte[] key = { 36, 48, 43, 112, 101, 105, 67, 89, 75, 83, 79, 38, 85, 74, 81, 90, 89, 94, 120, 83, 98, 33, 65, 85, 106, 70, 51, 79, 101, 79, 77, 76 };
        byte[] iv = { 50, 135, 251, 183, 12, 14, 254, 193, 24, 121, 132, 152, 204, 141, 211, 119 };

        string luaScript = File.ReadAllText(path);
        byte[] encrypt = EncryptionHelper.Encrypt(luaScript, key, iv);
        string base64 = Convert.ToBase64String(encrypt);
        File.WriteAllText(path, base64);
        Debug.Log("Encrypt success");
    }

    public static void CheckSumLua(string path)
    {                
        string checkSum =  AssetBundleManager.GenerateSHA256ChecksumForFile(path);
        var guidPopup = AssetDatabase.FindAssets("RemoteConfig t:Prefab", null);
        foreach (var guid in guidPopup)
        {
            var remotePath = AssetDatabase.GUIDToAssetPath(guid);
            var remoteConfigTool = AssetDatabase.LoadAssetAtPath<RemoteConfigTool>(remotePath);
            if (remoteConfigTool != null)
            {
                remoteConfigTool.AddKey("LuaCheckSum", checkSum);
            }
        }
    }

    public static void MoveLuaToAsset(string path, string ReleaseOrDev)
    {
        string AssetPath = Application.dataPath + "/../asset-services/asset/" + ReleaseOrDev + "/build.lua";
        File.Copy(path + "build.lua", AssetPath, true);
        Debug.Log("Move Lua Success");
    }
    #endregion
}
