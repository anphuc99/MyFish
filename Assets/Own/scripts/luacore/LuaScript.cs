using MoonSharp.Interpreter;
using Sirenix.OdinInspector;
using Sirenix.Utilities.Editor;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UnityEngine;

public enum LuaType
{
    String,
    Number,
    Table,
    GameObject,
    Transform,
    LuaComponent
}

[Serializable]
public class LuaSerializable
{    
    public string param;
    public LuaType type;
    
    [ShowIf("type", LuaType.String)]
    public string @string;
    [ShowIf ("type", LuaType.Number)]
    public int number;
    [ShowIf("type", LuaType.Table)]
    [NonSerialized]
    [ShowInInspector]
    public List<LuaSerializable> table;
    [ShowIf("type", LuaType.GameObject)] 
    public GameObject gameObject;
    [ShowIf("type", LuaType.Transform)] 
    public Transform transform;
    [ShowIf("type", LuaType.LuaComponent)]
    public LuaScript luaComponent;
}

public class LuaScript : MonoBehaviour
{
    [FilePath(ParentFolder  = "Assets/Resources/Luascript")]
    [ValidateInput("CheckFileExistence", "File does not exist.", InfoMessageType.Error)]
    public string filePathLua;
    [ReadOnly]
    public string classLua;
    public List<LuaSerializable> @params = new List<LuaSerializable>();

    [HideInInspector]
    public bool isInitialized = false;
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
    public void Awake()
    {
        if (!isInitialized)return;
        
        if (_luaObject == null)
        {
            SetLuaObject();
        }
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "Awake");
    }

    private void Start()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "Start");        
    }

    private void OnEnable()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnEnable");
    }
    private void OnDisable()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnDisable");
    }

    private void OnDestroy()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnDestroy");
        LuaCore.Instance.UnityEvent_RemoveInstanceID(GetInstanceID());
        _luaObject = null;
    }

    private void SetLuaObject()
    {        
        try
        {
            Table paramLua = ConvertLuaParamToLua();
            var Lib = LuaCore.GetGlobal("Lib");
            _luaObject =Lib.Table.Get("SetObject").Function.Call(classLua, GetInstanceID(), gameObject.GetInstanceID(),transform.GetInstanceID(), paramLua);            
            LuaCore.Instance.AddLuaObject(GetInstanceID(), this);                    
            LuaCore.Instance.LuaTransformAddTransform(transform.GetInstanceID(), transform);
        }
        catch(ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
        }
    }

    private Table ConvertLuaParamToLua()
    {
        if (@params.Count < 0)
        {
            Table table = LuaCore.CreateTable();
            foreach(var param in @params)
            {
                switch (param.type)
                {
                    case LuaType.String:
                        table[param.param] = param.@string;
                        break;
                    case LuaType.Number:
                        table[param.param] = param.number;
                        break;
                    case LuaType.LuaComponent:
                        if (param.luaComponent != null)
                        {
                            table[param.param] = param.luaComponent.luaObject;
                        }
                        break;
                }
            }
            return table;
        }
        return null;
    }

    private string ConvertPathToLuaRequire()
    {
        string path = filePathLua.Replace(".lua", "").Substring(4).Replace('/','.');        
        return path;
    }


#if UNITY_EDITOR
    public class LuaTypeCode
    {
        public string name;
        public string type;
    }

    [OnInspectorGUI]
    private void OnChangFileLua()
    {
        isInitialized = true;
        if (File.Exists(LuaCore.assetFile + filePathLua))
        {
            string data = File.ReadAllText(LuaCore.assetFile + filePathLua);
            List<LuaTypeCode> attrLua = ParseLuaClass(data);
            classLua = GetClassNames(data);
            Dictionary<string, LuaType> luaType = new Dictionary<string, LuaType>()
            {
                {"number", LuaType.Number},
                {"string", LuaType.String},
                {"table", LuaType.Table},
                {"GameObject", LuaType.GameObject},
                {"Transform", LuaType.Transform},
            };
            List<LuaSerializable> luaSerializables = new List<LuaSerializable>();
            // thêm các thuộc tính mới
            foreach (var attr in attrLua)
            {
                LuaType type;
                if (!luaType.TryGetValue(attr.type, out type))
                {
                    type = LuaType.LuaComponent;
                }

                luaSerializables.Add(new LuaSerializable()
                {
                    type = type,
                    param = attr.name
                });
            }
            foreach (var luaSerializable in luaSerializables)
            {
                LuaSerializable luaSerializable2 = @params.Find(x => x.param == luaSerializable.param && x.type == luaSerializable.type);
                if (luaSerializable2 == null)
                {
                    luaSerializable2 = new LuaSerializable();
                    luaSerializable2.param = luaSerializable.param;
                    luaSerializable2.type = luaSerializable.type;
                    @params.Add(luaSerializable);
                }
            }
            // xóa thuộc tính thừa
            List<LuaSerializable> remove = new List<LuaSerializable>();

            foreach(var param in @params)
            {
                LuaSerializable luaSerializable = luaSerializables.Find(x => x.param == param.param && x.type == param.type);
                if(luaSerializable == null)
                {
                    remove.Add(param);
                }
            }

            foreach(var param in remove)
            {
                @params.Remove(param);
            }

            // sắp xếp lại thuộc tính
            for (int i = 0; i < luaSerializables.Count; i++)
            {
                var luaSerializable = luaSerializables[i];
                LuaSerializable luaSerializable1 = @params.Find(x => x.param == luaSerializable.param);
                @params.Remove(luaSerializable1);
                @params.Insert(i, luaSerializable1);
            }
        }
    }
    private bool CheckFileExistence(string path)
    {
        return File.Exists(LuaCore.assetFile + path);
    }
    public List<LuaTypeCode> ParseLuaClass(string luaCode)
    {
        List<LuaTypeCode> luaAttributes = new List<LuaTypeCode>();

        // Sử dụng biểu thức chính quy để tìm các dòng chứa thông tin về thuộc tính
        var matches = Regex.Matches(luaCode, @"---@field\s+(\w+)\s+(\w+)");

        foreach (Match match in matches)
        {            
            string attributeName = match.Groups[1].Value;
            string attributeType = match.Groups[2].Value;

            luaAttributes.Add(new LuaTypeCode()
            {
                name = attributeName,
                type = attributeType
            });
        }

        

        return luaAttributes;
    }

    static string GetClassNames(string luaCode)
    {
        var classLua = Regex.Matches(luaCode, @"---@class\s+(\w+)(?=\s*(:|\n))");
        foreach (Match match in classLua)
        {
            return match.Groups[1].Value;
        }
        return "";
    }
#endif
}
