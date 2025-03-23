using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SFB;
using System.IO;
using System;
using MoonSharp.Interpreter;

[MoonSharpUserData]
public class APIFile
{

    public static string ReadAllBytes(string path)
    {
        byte[] bytes = File.ReadAllBytes(path);
        return Convert.ToBase64String(bytes);
    }

    public static string ReadAllText(string path)
    {
        return File.ReadAllText(path);
    }

    public static void WriteAllBytes(string path, string base64)
    {
        byte[] bytes = Convert.FromBase64String(base64);
        File.WriteAllBytes(path, bytes);
    }

    public static void WriteAllText(string path, string contents)
    {
        File.WriteAllText(path, contents);
    }

    public static void AppendAllText(string path, string contents)
    {
        File.AppendAllText(path, contents);
    }

    public static void OpenPanel(Closure callback, string directory, DynValue extensions, bool multiselect)
    {
#if UNITY_EDITOR
        var ets = new List<ExtensionFilter>();

        if (extensions.Type == DataType.Table)
        {
            string filterName = extensions.Table.Get("filterName").String;
            Table filterExtensions = extensions.Table.Get("filterExtensions").Table;
            List<string> tail = new List<string>();
            foreach (var t in filterExtensions.Pairs)
            {
                tail.Add(t.Value.String);
            }

            ets.Add(new ExtensionFilter(filterName, tail.ToArray()));
        }


        StandaloneFileBrowser.OpenFilePanelAsync("Open File", directory, ets.ToArray(), multiselect, (string[] paths) =>
        {
            Table table = LuaCore.CreateTable();
            foreach (string path in paths)
            {
                table.Append(DynValue.NewString(path));
            }
            callback.CallFunction(table);
        });
        return;
#endif
        if (extensions.Type == DataType.Table)
        {
            string filterName = extensions.Table.Get("filterName").String;
            Table filterExtensions = extensions.Table.Get("filterExtensions").Table;
            List<string> tail = new List<string>();
            foreach (var t in filterExtensions.Pairs)
            {
                tail.Add(t.Value.String);
            }

            List<string> fileTypes = new List<string>();
            foreach (var t in tail)
            {
                string fileType = NativeFilePicker.ConvertExtensionToFileType(t);
                fileTypes.Add(fileType);
                Debug.Log(fileType);
            }            

            if (multiselect)
            {
                NativeFilePicker.PickMultipleFiles((paths) =>
                {
                    if (paths == null)
                        Debug.Log("Operation cancelled");
                    else
                    {
                        Table table = LuaCore.CreateTable();
                        foreach (string path in paths)
                        {
                            table.Append(DynValue.NewString(path));
                        }
                        callback.CallFunction(table);
                    }
                }, fileTypes.ToArray());
            }
            else
            {
                NativeFilePicker.Permission permission = NativeFilePicker.PickFile((path) =>
                {
                    if (path == null)
                        Debug.Log("Operation cancelled");
                    else
                    {
                        Debug.Log("Picked file: " + path);
                        Table table = LuaCore.CreateTable();                        
                        table.Append(DynValue.NewString(path));
                        callback.CallFunction(table);
                    }

                }, fileTypes.ToArray());
            }
        }
    }



}
