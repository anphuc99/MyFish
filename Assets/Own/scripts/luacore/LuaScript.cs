using FSMC.Runtime;
using MoonSharp.Interpreter;
using Sirenix.OdinInspector;
using Spine.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using TMPro;
using Unity.VisualScripting;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

public enum LuaType
{
    None = -1,
    String,
    Number,
    Boolean,
    Table,
    GameObject,
    Transform,
    LuaComponent,
    Image,
    Sprite,
    Button,
    Text,
    InputField,
    TextMeshProGUI,
    Slider,
    Scrollbar,
    SpriteRenderer,
    RectTransform,
    LuaScriptableObject,
    FSMC_Executer,
    AudioSource,
    AudioClip,
    SkeletonGraphic,
    SkeletonAnimation,
    Color,
    Vector2,
    Vector3,
    Quaternion,
    Toggle,
    TextMeshPro,
    TMP_InputField,

}

[Serializable]
public class LuaSerializable
{
#if !UNTY_BUILD_RELEASE
    public Action OnValueChange;
#endif
    [OnValueChanged("OnChange")]
    public string param;
    [OnValueChanged("OnChange")]
    public LuaType type;
    
    [ShowIf("type", LuaType.String)]    
    [OnValueChanged("OnChange")]
    [TextArea]
    public string @string;
    [ShowIf ("type", LuaType.Number)]
    [OnValueChanged("OnChange")]
    public float number;
    [ShowIf("type", LuaType.Boolean)]
    [OnValueChanged("OnChange")]
    public bool boolean;
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
    [ShowIf("type", LuaType.InputField)]
    [OnValueChanged("OnChange")]
    public InputField inputField;
    [ShowIf("type", LuaType.TextMeshProGUI)]
    [OnValueChanged("OnChange")]
    public TextMeshProUGUI textMeshProGUI;
    [ShowIf("type", LuaType.Slider)]
    [OnValueChanged("OnChange")]
    public Slider slider;
    [ShowIf("type", LuaType.Scrollbar)]
    [OnValueChanged("OnChange")]
    public Scrollbar scrollbar;
    [ShowIf("type", LuaType.SpriteRenderer)]
    [OnValueChanged("OnChange")]
    public SpriteRenderer spriteRenderer;
    [ShowIf("type", LuaType.RectTransform)]
    [OnValueChanged("OnChange")]
    public RectTransform rectTransform;
    [ShowIf("type", LuaType.LuaScriptableObject)]
    [OnValueChanged("OnChange")]
    public LuaScriptableObject luaScriptObject;
    [ShowIf("type", LuaType.FSMC_Executer)]
    [OnValueChanged("OnChange")]
    public FSMC_Executer FSMC_Executer;
    [ShowIf("type", LuaType.AudioSource)]
    [OnValueChanged("OnChange")]
    public AudioSource audioSource;
    [ShowIf("type", LuaType.AudioClip)]
    [OnValueChanged("OnChange")]
    public AudioClip audioClip;
    [ShowIf("type", LuaType.SkeletonGraphic)]
    [OnValueChanged("OnChange")]
    public SkeletonGraphic skeletonGraphic;
    [ShowIf("type", LuaType.SkeletonAnimation)]
    [OnValueChanged("OnChange")]
    public SkeletonAnimation skeletonAnimation;
    [ShowIf("type", LuaType.Color)]
    [OnValueChanged("OnChange")]
    public Color color;
    [ShowIf("type", LuaType.Vector2)]
    [OnValueChanged("OnChange")]
    public Vector2 vector2;
    [ShowIf("type", LuaType.Vector3)]
    [OnValueChanged("OnChange")]
    public Vector3 vector3;
    [ShowIf("type", LuaType.Quaternion)]
    [OnValueChanged("OnChange")]
    public Quaternion quaternion;
    [ShowIf("type", LuaType.Toggle)]
    [OnValueChanged("OnChange")]
    public Toggle toggle;
    [ShowIf("type", LuaType.TextMeshPro)]
    [OnValueChanged("OnChange")]
    public TextMeshPro textMeshPro;
    [ShowIf("type", LuaType.TMP_InputField)]
    [OnValueChanged("OnChange")]
    public TMP_InputField TMP_InputField;

#if !UNTY_BUILD_RELEASE
    private void OnChange()
    {        
        OnValueChange?.Invoke();
    }
#endif
}

public class LuaScript : MonoBehaviour
{
    [Sirenix.OdinInspector.FilePath(ParentFolder  = "Assets/Own/Luascript")]
    [ValidateInput("CheckFileExistence", "File does not exist.", InfoMessageType.Error)]
    public string filePathLua;
    [ReadOnly]
    public string classLua;
    [HideInInspector]
    public string lastUpdate;

    public List<LuaSerializable> @params = new List<LuaSerializable>();

    [HideInInspector] 
    public bool isInitialized = false;
    public DynValue luaObject
    {
        get
        {
            if (!LuaCore.Instance.CheckScript(_luaObject))
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
        if (!LuaCore.Instance.CheckScript(_luaObject))
        {
            SetLuaObject();
        }
#if !UNTY_BUILD_RELEASE
        DynValue Lib = LuaCore.GetGlobal("Lib");
        string path = Lib.Table.Get("GetAttrObject").Function.CallFunction(_luaObject, "__path").String;
        filePathLua = path;
        OnChangFileLua(@params, filePathLua, ref classLua);
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
#if !UNTY_BUILD_RELEASE
        LeanTween.cancel(gameObject);
#endif
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

#if !UNTY_BUILD_RELEASE
    [FoldoutGroup("Unit Test")]
    public string function;
    [FoldoutGroup("Unit Test")]        
    public List<LuaSerializable> UnitParams;
    [FoldoutGroup("Unit Test")]
    [Button]
    private void Test()
    {
        object[] objs = new object[UnitParams.Count];
        for(int i = 0; i < UnitParams.Count; i++)
        {
            var p = UnitParams[i];
            p.param = "param";
            Table table = ConvertLuaParamToLua(new List<LuaSerializable> { p });
            objs[i] = table.Get("param");
        }
        LuaCore.ExecuteFuntion(_luaObject, function, objs);
    }
#endif
    private void SetLuaObject()
    {        
        try
        {
            Table paramLua = ConvertLuaParamToLua(@params);
            var Lib = LuaCore.GetGlobal("Lib");
            _luaObject =Lib.Table.Get("SetObject").Function.CallFunction(classLua, GetInstanceID(), gameObject.GetInstanceID(),transform.GetInstanceID(), paramLua, tag);            
            LuaCore.Instance.LuaObjectAddLuaObject(GetInstanceID(), this);                    
            LuaCore.Instance.LuaTransformAddTransform(transform.GetInstanceID(), transform);
        }
        catch(ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\nFile path: "+ filePathLua + "\n" + ex.StackTrace);
        }

#if !UNTY_BUILD_RELEASE
        //lastMD5Hash = GetMD5Hash(LuaCore.assetFile + filePathLua);
        //LeanTween.value(gameObject, 0, 1000000000, 1000000000).setOnUpdate((float value) =>
        //{
        //    DebugRealTime();
        //});
#endif
    }

    public static LuaType ConvertStringToLuaType(string str)
    {
        if(str == "fun")
        {
            return LuaType.None;
        }
        Dictionary<string, LuaType> luaType = new Dictionary<string, LuaType>()
        {
            {"number", LuaType.Number},
            {"string", LuaType.String},
            {"boolean", LuaType.Boolean},
            {"table", LuaType.Table},
            {"GameObject", LuaType.GameObject},
            {"Transform", LuaType.Transform},
            {"Image", LuaType.Image},
            {"Sprite", LuaType.Sprite},
            {"Button", LuaType.Button},
            {"Text", LuaType.Text},
            {"TextMeshProGUI", LuaType.TextMeshProGUI},
            {"Slider", LuaType.Slider},
            {"Scrollbar", LuaType.Scrollbar},
            {"SpriteRenderer", LuaType.SpriteRenderer},
            {"InputField", LuaType.InputField},
            {"RectTransform", LuaType.RectTransform},
            {"LuaScriptableObject", LuaType.LuaScriptableObject},
            {"FSMC_Executer", LuaType.FSMC_Executer},
            {"AudioSource", LuaType.AudioSource},
            {"AudioClip", LuaType.AudioClip},
            {"SkeletonGraphic", LuaType.SkeletonGraphic},
            {"SkeletonAnimation", LuaType.SkeletonAnimation},
            {"Color", LuaType.Color},
            {"Vector2", LuaType.Vector2},
            {"Vector3", LuaType.Vector3},
            {"Quaternion", LuaType.Quaternion},
            {"Toggle", LuaType.Toggle},
            {"TextMeshPro", LuaType.TextMeshPro},
            {"TMP_InputField", LuaType.TMP_InputField},
        };
        LuaType type;
        if (!luaType.TryGetValue(str, out type))
        {
#if !UNTY_BUILD_RELEASE
            if (CheckIsType("ScriptableObject", str))
            {
                type = LuaType.LuaScriptableObject;
            }
            else
            {
                type = LuaType.LuaComponent;
            }
#endif
        }
        return type;
    }
    public static Table ConvertLuaParamToLua(List<LuaSerializable> @params)
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
                    case LuaType.Boolean:
                        table[param.param] = param.boolean;
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
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddGameObject").Function.CallFunction(param.gameObject.GetInstanceID(), param.gameObject.tag);
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.CallFunction(param.gameObject.transform.GetInstanceID(),param.gameObject.GetInstanceID(), param.gameObject.tag);
                        }
                        break;
                    case LuaType.Transform:
                        if (param.transform != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.transform.gameObject.GetInstanceID(), param.transform);
                            LuaCore.Instance.LuaTransformAddTransform(param.transform.GetInstanceID(), param.transform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.CallFunction(param.transform.GetInstanceID(), param.transform.gameObject.GetInstanceID(), param.transform.tag);
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
                                sprite["sprite"] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddSprite").Function.CallFunction(param.image.sprite.GetInstanceID());
                            }
                            LuaCore.Instance.LuaObjectAddLuaObject(param.image.GetInstanceID(), param.image);
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.image.transform.GetInstanceID(), param.image.gameObject.GetInstanceID(), param.image.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("Image", param.image.GetInstanceID(), param.image.gameObject.GetInstanceID(), param.image.transform.GetInstanceID(), sprite, param.image.tag);                        
                        }
                        break;
                    case LuaType.Sprite:
                        if (param.sprite != null)
                        {
                            LuaCore.Instance.AddLuaSprite(param.sprite);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddSprite").Function.CallFunction(param.sprite.GetInstanceID());
                        }                        
                        break;
                    case LuaType.Button:
                        if (param.button != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.button.GetInstanceID(), param.button);
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.button.transform.GetInstanceID(), param.button.gameObject.GetInstanceID(), param.button.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("Button", param.button.GetInstanceID(), param.button.gameObject.GetInstanceID(), param.button.transform.GetInstanceID(), null, param.button.tag);
                            param.button.onClick.AddListener(() => ButtonOnClick(table.Get(param.param), param.button));
                        }
                        break;
                    case LuaType.Text:
                        if(param.text != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.text.GetInstanceID(), param.text);
                            Table txt = LuaCore.CreateTable();
                            txt["text"] = param.text.text;
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.text.transform.GetInstanceID(), param.text.gameObject.GetInstanceID(), param.text.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("Text", param.text.GetInstanceID(), param.text.gameObject.GetInstanceID(), param.text.transform.GetInstanceID(), txt, param.text.tag);                            
                        }
                        break;
                    case LuaType.TextMeshProGUI:
                        if(param.textMeshProGUI != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.textMeshProGUI.GetInstanceID(), param.textMeshProGUI);
                            Table txt = LuaCore.CreateTable();
                            txt["text"] = param.textMeshProGUI.text;
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.textMeshProGUI.transform.GetInstanceID(), param.textMeshProGUI.gameObject.GetInstanceID(), param.textMeshProGUI.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("TextMeshProGUI", param.textMeshProGUI.GetInstanceID(), param.textMeshProGUI.gameObject.GetInstanceID(), param.textMeshProGUI.transform.GetInstanceID(), txt, param.textMeshProGUI.tag);
                        }
                        break;
                    case LuaType.InputField:
                        if(param.inputField != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.inputField.GetInstanceID(), param.inputField);
                            Table txt = LuaCore.CreateTable();
                            txt["text"] = param.inputField.text;
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.inputField.transform.GetInstanceID(), param.inputField.gameObject.GetInstanceID(), param.inputField.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("InputField", param.inputField.GetInstanceID(), param.inputField.gameObject.GetInstanceID(), param.inputField.transform.GetInstanceID(), txt, param.inputField.tag);
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
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.slider.transform.GetInstanceID(), param.slider.gameObject.GetInstanceID(), param.slider.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("Slider", param.slider.GetInstanceID(), param.slider.gameObject.GetInstanceID(), param.slider.transform.GetInstanceID(), slider, param.slider.tag);
                        }
                        break;
                    case LuaType.Scrollbar:
                        if(param.scrollbar != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.scrollbar.GetInstanceID(), param.scrollbar);
                            Table slider = LuaCore.CreateTable();
                            slider["value"] = param.scrollbar.value;
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.scrollbar.transform.GetInstanceID(), param.scrollbar.gameObject.GetInstanceID(), param.scrollbar.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("Scrollbar", param.scrollbar.GetInstanceID(), param.scrollbar.gameObject.GetInstanceID(), param.scrollbar.transform.GetInstanceID(), slider, param.scrollbar.tag);
                        }
                        break;
                    case LuaType.SpriteRenderer:
                        if(param.spriteRenderer != null)
                        {
                            Table sprite = null;
                            if (param.spriteRenderer.sprite != null)
                            {
                                LuaCore.Instance.AddLuaSprite(param.spriteRenderer.sprite);
                                sprite = LuaCore.CreateTable();
                                sprite["sprite"] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddSprite").Function.CallFunction(param.spriteRenderer.sprite.GetInstanceID());
                            }
                            LuaCore.Instance.LuaObjectAddLuaObject(param.spriteRenderer.GetInstanceID(), param.spriteRenderer);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("SpriteRenderer", param.spriteRenderer.GetInstanceID(), param.spriteRenderer.gameObject.GetInstanceID(), param.spriteRenderer.transform.GetInstanceID(), sprite, param.spriteRenderer.tag);
                        }
                        break;
                    case LuaType.RectTransform:
                        if(param.rectTransform != null)
                        {                            
                            LuaCore.Instance.LuaObjectAddLuaObject(param.rectTransform.gameObject.GetInstanceID(), param.rectTransform);
                            LuaCore.Instance.LuaTransformAddTransform(param.rectTransform.GetInstanceID(), param.rectTransform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.rectTransform.GetInstanceID(), param.rectTransform.gameObject.GetInstanceID(), param.rectTransform.tag);
                        }
                        break;                    
                    case LuaType.FSMC_Executer:
                        if (param.FSMC_Executer != null)
                        {                            
                            LuaCore.Instance.LuaObjectAddLuaObject(param.FSMC_Executer.GetInstanceID(), param.FSMC_Executer);
                            LuaCore.Instance.LuaTransformAddTransform(param.FSMC_Executer.transform.GetInstanceID(), param.FSMC_Executer.transform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("FSMC_Executer", param.FSMC_Executer.GetInstanceID(), param.FSMC_Executer.gameObject.GetInstanceID(), param.FSMC_Executer.transform.GetInstanceID(), null, param.FSMC_Executer.tag);
                            if (param.FSMC_Executer is LuaFSMC_Executer)
                            {
                                var luaFSMC_Executer = (LuaFSMC_Executer)param.FSMC_Executer;
                                Table table1 = ConvertLuaParamToLua(luaFSMC_Executer.luaParams);
                                table.Get(param.param).Table.Set("params", DynValue.NewTable(table1));
                                LuaFSMC_Executer.globalExecuter.Add(luaFSMC_Executer, table.Get(param.param));  
                            }
                        }
                        break;
                    case LuaType.AudioSource:
                        if(param.audioSource != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.audioSource.GetInstanceID(), param.audioSource);
                            LuaCore.Instance.LuaTransformAddTransform(param.audioSource.transform.GetInstanceID(), param.audioSource.transform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("AudioSource", param.audioSource.GetInstanceID(), param.audioSource.gameObject.GetInstanceID(), param.audioSource.transform.GetInstanceID(), null, param.audioSource.tag);
                        }
                        break;
                    case LuaType.AudioClip: 
                        if (param.audioClip != null)
                        {
                            LuaCore.Instance.AddLuaAudioClip(param.audioClip);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddAudioClip").Function.CallFunction(param.audioClip.GetInstanceID());
                        }
                        break;
                    case LuaType.SkeletonGraphic:
                        if(param.skeletonGraphic != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.skeletonGraphic.GetInstanceID(), param.skeletonGraphic);
                            LuaCore.Instance.LuaTransformAddTransform(param.skeletonGraphic.transform.GetInstanceID(), param.skeletonGraphic.transform);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("SkeletonGraphic", param.skeletonGraphic.GetInstanceID(), param.skeletonGraphic.gameObject.GetInstanceID(), param.skeletonGraphic.transform.GetInstanceID(), null, param.skeletonGraphic.tag);
                        }
                        break;
                    case LuaType.Color:
                        Table color = LuaCore.Instance.ConverColorToTable(param.color);
                        table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("CreateColor").Function.CallFunction(color);
                        break;
                    case LuaType.Vector2:
                        Table vector2 = LuaCore.Instance.ConvertV2ToTable(param.vector2);
                        table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("CreateVector2").Function.CallFunction(vector2);
                        break;
                    case LuaType.Vector3:
                        Table vector3 = LuaCore.Instance.ConvertV3ToTable(param.vector3);
                        table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("CreateVector3").Function.CallFunction(vector3);
                        break;
                    case LuaType.Quaternion:
                        Table quaternion = LuaCore.Instance.ConvertQuaternionToTable(param.quaternion);
                        table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("CreateQuaternion").Function.CallFunction(quaternion);
                        break;
                    case LuaType.Toggle:
                        if(param.toggle != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.toggle.GetInstanceID(), param.toggle);
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.toggle.transform.GetInstanceID(), param.toggle.gameObject.GetInstanceID(), param.toggle.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("Toggle", param.toggle.GetInstanceID(), param.toggle.gameObject.GetInstanceID(), param.toggle.transform.GetInstanceID(), null, param.toggle.tag);
                        }
                        break;
                    case LuaType.TextMeshPro:
                        if(param.textMeshPro != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.textMeshPro.GetInstanceID(), param.textMeshPro);
                            Table txt = LuaCore.CreateTable();
                            txt["text"] = param.textMeshPro.text;                            
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("TextMeshPro", param.textMeshPro.GetInstanceID(), param.textMeshPro.gameObject.GetInstanceID(), param.textMeshPro.transform.GetInstanceID(), txt, param.textMeshPro.tag);
                        }
                        break;
                    case LuaType.TMP_InputField:
                        if (param.TMP_InputField != null)
                        {
                            LuaCore.Instance.LuaObjectAddLuaObject(param.TMP_InputField.GetInstanceID(), param.TMP_InputField);
                            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(param.TMP_InputField.transform.GetInstanceID(), param.TMP_InputField.gameObject.GetInstanceID(), param.TMP_InputField.tag);
                            table[param.param] = LuaCore.GetGlobal("Lib").Table.Get("SetObject").Function.CallFunction("TMP_InputField", param.TMP_InputField.GetInstanceID(), param.TMP_InputField.gameObject.GetInstanceID(), param.TMP_InputField.transform.GetInstanceID(), null, param.TMP_InputField.tag);
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
        try
        {            
            LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.CallFunction(_luaObject, nameFunction);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }

    private static void ButtonOnClick(DynValue button, Button btn)
    {
        LuaCore.Instance.UnityEvent_Emit(button, btn.GetInstanceID(), "ButtonOnClick");
    }

    private static string ConvertPathToLuaRequire(string filePathLua)
    {
        string path = filePathLua.Replace(".lua", "").Substring(4).Replace('/','.');        
        return path;
    }



#if !UNTY_BUILD_RELEASE

    public class LuaTypeCode
    {
        public string name;
        public string type;
    }    

    [OnInspectorGUI]
    public void UpdateCode()
    {
        isInitialized = true;
        OnChangFileLua(@params, filePathLua, ref classLua);          
    }

    public static void OnChangFileLua(List<LuaSerializable> @params, string filePathLua, ref string classLua)
    {
        if (File.Exists(LuaCore.assetFile + filePathLua))
        {
            string data = File.ReadAllText(LuaCore.assetFile + filePathLua);
            List<LuaTypeCode> attrLua = new();
            classLua = GetClassNames(data);
            string parent = GetParentClassNames(data);            
            void recursive(string className)
            {
                string data = GetDataClass(className);
                string nameClass = GetClassNames(data);
                string parent = GetParentClassNames(data);
                if(parent != "MonoBehaviour" && parent != "ScriptableObject")
                {
                    if(parent != null)
                    {
                        recursive(parent);
                    }
                }
                List<LuaTypeCode> attrLua2 = ParseLuaClass(data);
                attrLua.AddRange(attrLua2);
            }
            if (parent != "MonoBehaviour" && parent != "ScriptableObject")
            {
                if(parent != null)
                {
                    recursive(parent);
                }
            }
            attrLua.AddRange(ParseLuaClass(data));
            List<LuaSerializable> luaSerializables = new List<LuaSerializable>();
            // thêm các thuộc tính mới
            foreach (var attr in attrLua)
            {
                LuaType type = ConvertStringToLuaType(attr.type);                
                if(type == LuaType.None)
                {
                    continue;
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
    private static bool CheckFileExistence(string path)
    {
        return File.Exists(LuaCore.assetFile + path);
    }
    public static List<LuaTypeCode> ParseLuaClass(string luaCode)
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

    private static string GetClassNames(string luaCode)
    {
        var classLua = Regex.Matches(luaCode, @"---@class\s+(\w+)(?=\s*(:|\n))");
        foreach (Match match in classLua)
        {
            return match.Groups[1].Value;
        }
        return "";
    } 
    
    private static string GetParentClassNames(string luaCode)
    {        
        var classLua = Regex.Matches(luaCode, @"---@class\s+(\w+)\s*:\s*(\w+)");
        foreach (Match match in classLua)
        {
            return match.Groups[2].Value;
        }
        return "";
    }

    public static bool CheckIsType(string type, string classLua)
    {
        string luaCode = GetDataClass(classLua);
        string parent = GetParentClassNames(luaCode);
        if (classLua != type && parent != type)
        {
            if(!string.IsNullOrEmpty(parent))
            {
                return CheckIsType(type, parent);
            }
            else
            {
                return false;
            }
        }
        return true;
    }

    public static string GetDataClass(string parent)
    {
        var luaFiles = GetLuaFiles(LuaCore.assetFile);

        // Hiển thị danh sách các tệp tin .lua
        foreach (var luaFile in luaFiles)
        {
            string data = File.ReadAllText(luaFile);
            string className = GetClassNames(data);
            if (className == parent)
            {
                return data;
            }
        }

        return null;
    }

    private static string[] GetLuaFiles(string directoryPath)
    {
        try
        {
            // Lấy tất cả các tệp tin .lua trong thư mục và thư mục con
            string[] luaFiles = Directory.GetFiles(directoryPath, "*.lua", SearchOption.AllDirectories);

            return luaFiles;
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
            return null;
        }
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
    private string lastMD5Hash;
    private void DebugRealTime()
    {        
        string currentMD5Hash = GetMD5Hash(LuaCore.assetFile + filePathLua);

        if (currentMD5Hash != lastMD5Hash)
        {
            try
            {
                LuaCore.GetGlobal("Lib").Table.Get("RealTimeCompiler").Function.CallFunction(_luaObject, classLua);

                lastMD5Hash = currentMD5Hash;
            }
            catch (ScriptRuntimeException ex)
            {
                Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);                
            }

        }
    }

    public static string GetMD5Hash(string filePath)
    {
        using (var md5 = MD5.Create())
        {
            using (var stream = File.OpenRead(filePath))
            {
                var hash = md5.ComputeHash(stream);
                return BitConverter.ToString(hash).Replace("-", String.Empty).ToLower();
            }
        }
    }

    private void OnParamChange()
    {
        SetChange(@params);
        Table table = ConvertLuaParamToLua(@params);
        foreach(var param in table.Keys)
        {
            LuaCore.GetGlobal("Lib").Table.Get("SetAttrObject").Function.CallFunction(_luaObject, param, table.Get(param));
        }
    }
#endif
}