using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

public class BuildSystem 
{
    [MenuItem("Tools/Build/Dev")]
    public static void BuildDev()
    {
        RemoveDefineSymbol("UNITY_RELEASE");
        AddSymbols("UNTY_BUILD_RELEASE");
        AddSymbols("UNITY_DEVELOPMENT");
    }
    [MenuItem("Tools/Build/Release")]
    public static void BuildRelease()
    {
        RemoveDefineSymbol("UNITY_DEVELOPMENT");
        AddSymbols("UNTY_BUILD_RELEASE");
        AddSymbols("UNITY_RELEASE");
    }

    [MenuItem("Tools/Build/NotBuild")]
    public static void NotBuild()
    {
        RemoveDefineSymbol("UNITY_RELEASE");
        RemoveDefineSymbol("UNTY_BUILD_RELEASE");
        RemoveDefineSymbol("UNITY_DEVELOPMENT");
    }

    static void AddSymbols(string Symbols)
    {
        string symbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup);

        // Kiểm tra xem symbol đã tồn tại chưa, nếu chưa thì thêm vào
        if (!symbols.Contains(Symbols))
        {
            symbols += ";" + Symbols;
            PlayerSettings.SetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup, symbols);
            Debug.Log("Added " + Symbols);
        }
        else
        {
            Debug.Log(Symbols + " already exists");
        }
    }

    public static void RemoveDefineSymbol(string symbolToRemove)
    {
        // Lấy tất cả các define symbols hiện tại cho nền tảng đã chọn (chẳng hạn như Standalone)
        BuildTargetGroup targetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        string defineSymbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(targetGroup);

        // Tách các define symbols thành một mảng
        var symbols = defineSymbols.Split(';');

        // Xóa symbol được chỉ định
        var newSymbols = string.Join(";", symbols.Where(s => s != symbolToRemove).ToArray());

        // Cập nhật define symbols
        PlayerSettings.SetScriptingDefineSymbolsForGroup(targetGroup, newSymbols);

        Debug.Log($"Removed symbol: {symbolToRemove}");
    }
}
