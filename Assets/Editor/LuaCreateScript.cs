using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.PackageManager.UI;
using UnityEngine;

public class LuaCreateScript : Editor
{
    [MenuItem("Assets/Create/Lua Script")]
    public static void CreateScript()
    {
        CustomInputDialog.ShowWindow("Create Lua Script", (fileName) =>
        {
            // Lấy đối tượng được chọn trong trình chỉnh sửa Unity
            UnityEngine.Object selectedObject = Selection.activeObject;

            // Kiểm tra xem đối tượng được chọn có phải là một thư mục không
            string selectedFolderPath = AssetDatabase.GetAssetPath(selectedObject);
            if (Directory.Exists(selectedFolderPath))
            {
                // Tạo tên file và đường dẫn đầy đủ trong thư mục được chọn
                string fileName2 = fileName + ".lua";
                string filePath = Path.Combine(selectedFolderPath, fileName2).Replace('\\','/');
                // Kiểm tra xem file đã tồn tại chưa
                if (!File.Exists(filePath))
                {
                    // Tạo nội dung bạn muốn đặt trong file
                    string fileContent =@$"
---@class {fileName} : MonoBehaviour
local {fileName} = class(""{fileName}"", MonoBehaviour)
{fileName}.__path = ""{filePath.Replace("Assets/Resources/Luascript/","")}""
function {fileName}:Start()
    
end

function {fileName}:Update()
    
end

return {fileName}
";

                    // Ghi nội dung vào file
                    File.WriteAllText(filePath, fileContent);

                    // Import file vào dự án để nó xuất hiện trong trình chỉnh sửa Unity
                    AssetDatabase.ImportAsset(filePath);

                    Debug.Log("Custom text file created at: " + filePath);
                }
                else
                {
                    Debug.LogWarning("File already exists at: " + filePath);
                }
            }
            else
            {
                Debug.LogWarning("Please select a folder in the Project window.");
            }
        });
    }
}


public class CustomInputDialog : EditorWindow
{
    private string userInput = "";
    private static Action<string> callBack;
    public static void ShowWindow(string title, Action<string> callback)
    {
        CustomInputDialog window = GetWindow<CustomInputDialog>(title);
        Vector2 windowSize = new Vector2(300, 150);
        window.minSize = windowSize;
        window.position = new Rect((Screen.currentResolution.width - windowSize.x) / 2, (Screen.currentResolution.height - windowSize.y) / 2, windowSize.x, windowSize.y);
        callBack = callback;
    }

    private void OnGUI()
    {
        userInput = EditorGUILayout.TextField("File Name:", userInput);

        if (GUILayout.Button("OK"))
        {
            callBack?.Invoke(userInput);
            callBack = null;
            Close(); // Đóng cửa sổ sau khi nhấp nút OK hoặc Cancel
        }
    }
}