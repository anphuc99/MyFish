using MoonSharp.Interpreter;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text.RegularExpressions;
using TMPro;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

public enum LuaType
{
    String,
    Number,
    Table,
    GameObject,
    Transform,
    LuaComponent,
    Image,
    Sprite,
    Button,
    Text,
    TextMeshPro,
    Slider,
    Scrollbar
}

[Serializable]
public class LuaSerializable
{
#if UNITY_EDITOR
    public Action OnValueChange;
#endif
    [OnValueChanged("OnChange")]
    public string param;
    [OnValueChanged("OnChange")]
    public LuaType type;
    
    [ShowIf("type", LuaType.String)]
    [OnValueChanged("OnChange")]
    public string @string;
    [ShowIf ("type", LuaType.Number)]
    [OnValueChanged("OnChange")]
    public float number;
    [ShowIf("type", LuaType.Table)]
    [OnValueChanged("OnChange")]
    public List<LuaSerializable> table = new();
    [ShowIf("type", LuaType.GameObject)]
    [OnValueChanged("OnChange")]
    public GameObject gameObject;
    [ShowIf("type", LuaType.Transform)]
    [OnValueChanged("OnChange")]
    public Transform transform;
    [ShowIf("type", LuaType.LuaComponent)]
    [OnValueChanged("OnChange")]
    public LuaScript luaComponent;
    [ShowIf("type", LuaType.Image)]
    [OnValueChanged("OnChange")]
    public Image image;
    [ShowIf("type", LuaType.Sprite)]
    [OnValueChanged("OnChange")]
    public Sprite sprite;  
    [ShowIf("type", LuaType.Button)]
    [OnValueChanged("OnChange")]
    public Button button;
    [ShowIf("type", LuaType.Text)]
    [OnValueChanged("OnChange")]
    public Text text;
    [ShowIf("type", LuaType.TextMeshPro)]
    [OnValueChanged("OnChange")]
    public TextMeshProUGUI textMeshPro;
    [ShowIf("type", LuaType.Slider)]
    [OnValueChanged("OnChange")]
    public Slider slider;
    [ShowIf("type", LuaType.Scrollbar)]
    [OnValueChanged("OnChange")]
    public Scrollbar scrollbar;

#if UNITY_EDITOR
    private void OnChange()
    {        
        OnValueChange?.Invoke();
    }
#endif
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
#if UNITY_EDITOR
        DynValue Lib = LuaCore.GetGlobal("Lib");
        string path = Lib.Table.Get("GetAttrObject").Function.Call(_luaObject, "__path").String;
        filePathLua = path;
        OnChangFileLua();
        SetChange(@params);
#endif
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

    private void OnMouseDown()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnMouseDown");
    }

    private void OnMouseUp()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnMouseUp");
    }

    private void OnMouseEnter()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnMouseEnter");
    }

    private void OnMouseExit()
    {
        LuaCore.Instance.UnityEvent_Emit(_luaObject, GetInstanceID(), "OnMouseExit");
    }    

    private void SetLuaObject()
    {        
        try
        {
            Table paramLua = ConvertLuaParamToLua(@params);
            var Lib = LuaCore.GetGlobal("Lib");
            _luaObject =Lib.Table.Get("SetObject").Function.Call(classLua, GetInstanceID(), gameObject.GetInstanceID(),transform.GetInstanceID(), paramLua, tag);            
            LuaCore.Instance.LuaObjectAddLuaObject(GetInstanceID(), this);                    
            LuaCore.Instance.LuaTransformAddTransform(transform.GetInstanceID(), transform);
        }
        catch(ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
        }
    }    
    private Table ConvertLuaParamToLua(List<LuaSerializable> @params)
    {
        if (@params.Count > 0)
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
                    case LuaType.Table:
                        table[param.param] = ConvertLuaParamToLua(param.table);
                        break;
                    case LuaType.GameObject:
                        if(param.gameObject != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaGameObject(param.gameObject);
                            LuaCore.Instance.LuaTransformAddTransform(param.gameObject.transform.GetInstanceID(), param.gameObject.transform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddGameObject").Function.Call(param.gameObject.GetInstanceID(), param.gameObject.tag);
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.Call(param.gameObject.transform.GetInstanceID(),param.gameObject.GetInstanceID(), param.gameObject.tag);
                        }
                        break;
                    case LuaType.Transform:
                        if (param.transform != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.transform.gameObject.GetInstanceID(), param.transform);
                            LuaCore.Instance.LuaTransformAddTransform(param.transform.GetInstanceID(), param.transform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.Call(param.transform.GetInstanceID(), param.transform.gameObject.GetInstanceID(), param.transform.tag);
                        }
                        break;
                    case LuaType.Image:
                        if(param.image != null)
                        {
                            Table sprite = null;
                            if(param.image.sprite != null)
                            {
                                LuaCore.Instance.AddLuaSprite(param.image.sprite);
                                sprite = LuaCore.CreateTable();
                                sprite["sprite"] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddSprite").Function.Call(param.image.sprite.GetInstanceID());
                            }
                            LuaCore.Instance.LuaObjectAddLuaObject(param.image.GetInstanceID(), param.image);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.Call("Image", param.image.GetInstanceID(), param.image.gameObject.GetInstanceID(), param.image.transform.GetInstanceID(), sprite);
                        }
                        break;
                    case LuaType.Sprite:
                        if (param.sprite != null)
                        {
                            LuaCore.Instance.AddLuaSprite(param.sprite);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddSprite").Function.Call(param.sprite.GetInstanceID());
                        }                        
                        break;
                    case LuaType.Button:
                        if (param.button != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.button.GetInstanceID(), param.button);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.Call("Button", param.button.GetInstanceID(), param.button.gameObject.GetInstanceID(), param.button.transform.GetInstanceID());
                            param.button.onClick.AddListener(() => ButtonOnClick(table.Get(param.param), param.button));
                        }
                        break;
                    case LuaType.Text:
                        if(param.text != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.text.GetInstanceID(), param.text);
                            Table txt = LuaCore.CreateTable();
                            txt["text"] = param.text.text;
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.Call("Text", param.text.GetInstanceID(), param.text.gameObject.GetInstanceID(), param.text.transform.GetInstanceID(), txt);                            
                        }
                        break;
                    case LuaType.TextMeshPro:
                        if(param.textMeshPro != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.textMeshPro.GetInstanceID(), param.textMeshPro);
                            Table txt = LuaCore.CreateTable();
                            txt["text"] = param.textMeshPro.text;
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.Call("TextMeshPro", param.textMeshPro.GetInstanceID(), param.textMeshPro.gameObject.GetInstanceID(), param.textMeshPro.transform.GetInstanceID(), txt);
                        }
                        break;
                    case LuaType.Slider:
                        if(param.slider != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.slider.GetInstanceID(), param.slider);
                            Table slider = LuaCore.CreateTable();
                            slider["value"] = param.slider.value;
                            slider["minValue"] = param.slider.minValue;
                            slider["maxValue"] = param.slider.maxValue;
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.Call("Slider", param.slider.GetInstanceID(), param.slider.gameObject.GetInstanceID(), param.slider.transform.GetInstanceID(), slider);
                        }
                        break;
                    case LuaType.Scrollbar:
                        if(param.scrollbar != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.scrollbar.GetInstanceID(), param.scrollbar);
                            Table slider = LuaCore.CreateTable();
                            slider["value"] = param.scrollbar.value;
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.Call("Scrollbar", param.scrollbar.GetInstanceID(), param.scrollbar.gameObject.GetInstanceID(), param.scrollbar.transform.GetInstanceID(), slider);
                        }
                        break;
                }
            }
            return table;
        }
        return null;
    }

    public void ExecuteFunction(string nameFunction)
    {
        foreach(var table in _luaObject.Table.Pairs)
        {
            Debug.Log(table.Key);
        }
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, nameFunction);
    }

    private void ButtonOnClick(DynValue button, Button btn)
    {
        LuaCore.Instance.UnityEvent_Emit(button, btn.GetInstanceID(), "ButtonOnClick");
    }

    private string ConvertPathToLuaRequire()
    {
        string path = filePathLua.Replace(".lua", "").Substring(4).Replace('/','.');        
        return path;
    }



#if UNITY_EDITOR

    private void Update()
    {
        DebugRealTime();
    }

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
                {"Image", LuaType.Image},
                {"Sprite", LuaType.Sprite},
                {"Button", LuaType.Button},
                {"Text", LuaType.Text},
                {"TextMeshPro", LuaType.TextMeshPro},
                {"Slider", LuaType.Slider},
                {"Scrollbar", LuaType.Scrollbar},
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

    private string GetClassNames(string luaCode)
    {
        var classLua = Regex.Matches(luaCode, @"---@class\s+(\w+)(?=\s*(:|\n))");
        foreach (Match match in classLua)
        {
            return match.Groups[1].Value;
        }
        return "";
    }
    
    private void SetChange(List<LuaSerializable> luaSerializables)
    {
        foreach(var param in luaSerializables)
        {
            param.OnValueChange = OnParamChange;
            if(param.type == LuaType.Table)
            {
                SetChange(param.table);
            }
        }
    }
    private DateTime lastModifiedTime;
    private void DebugRealTime()
    {
        DateTime currentModifiedTime = File.GetLastWriteTime(LuaCore.assetFile + filePathLua);

        if (currentModifiedTime != lastModifiedTime)
        {
            LuaCore.GetGlobal("Lib").Table.Get("RealTimeCompiler").Function.Call(_luaObject, ConvertPathToLuaRequire());

            lastModifiedTime = currentModifiedTime;
        }
    }

    private void OnParamChange()
    {
        SetChange(@params);
        Table table = ConvertLuaParamToLua(@params);
        foreach(var param in table.Keys)
        {
            LuaCore.GetGlobal("Lib").Table.Get("SetAttrObject").Function.Call(_luaObject, param, table.Get(param));
        }
    }
#endif
}
