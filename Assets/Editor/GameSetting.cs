using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class GameSetting : EditorWindow
{
    [MenuItem("Game Setting/Open persistentDataPath folder")]
    private static void OpenFile()
    {
        EditorUtility.RevealInFinder(Application.persistentDataPath);
    }

    [MenuItem("Game Setting/ Delete Save Files")]
    private static void DeleteSaveFile()
    {
        var folder = Application.persistentDataPath;
        if (Directory.Exists(folder))
        {
            var dirInfo = new DirectoryInfo(folder);

            foreach (var file in dirInfo.GetFiles())
            {
                file.Delete();
            }
        }

        PlayerPrefs.DeleteAll();
    }
}
