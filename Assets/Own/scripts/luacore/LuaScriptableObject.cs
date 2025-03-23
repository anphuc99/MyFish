using MoonSharp.Interpreter;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(fileName = "Lua Scriptable Object", menuName = "lua/create scriptable object")]
public class LuaScriptableObject : ScriptableObject
{
    [FilePath(ParentFolder = "Assets/Own/Luascript")]
    [ValidateInput("CheckFileExistence", "File does not exist.", InfoMessageType.Error)]
    public string filePathLua;
    [ReadOnly]
    public string classLua;
    public List<LuaSerializable> @params = new List<LuaSerializable>();

    public DynValue luaObject
    {
        get
        {
            if (_luaObject == null)
            {
                SetLuaObject();
            }

            return _luaObject;
        }
    }

    private DynValue _luaObject;

    private void SetLuaObject()
    {
        try
        {
            Table paramLua = LuaScript.ConvertLuaParamToLua(@params);
            _luaObject = LuaCore.GetGlobal("Lib").Table.Get("SetScriptable").Function.CallFunction(classLua, paramLua);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }


#if !UNTY_BUILD_RELEASE
    private bool CheckFileExistence(string path)
    {
        return File.Exists(LuaCore.assetFile + path);
    }
    [OnInspectorGUI]
    private void OnInspector()
    {
        LuaScript.OnChangFileLua(@params, filePathLua, ref classLua);
    }
    [Button]
    public void ReCompile()
    {
        SetLuaObject();
    }

#endif

}
