using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Serialization.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Sirenix.OdinInspector;
using SocketIOClient;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;
using UnityEngine.U2D;
using UnityEngine.UI;

public class LuaObject
{
    public GameObject gameObject;
    public Dictionary<int, UnityEngine.Component> components = new();
}

//public class LuaTransformMove
//{
//    public Transform transform;
//    public Vector3 posMove;
//}

//public struct LuaTransformRot
//{
//    public Transform transform;
//    public Vector3 rotMove;
//}

public interface IUpdate
{
    public void OnUpdate();
}

public partial class LuaCore : MonoBehaviour
{
    public static LuaCore Instance;
    private static Script luaScript;
    private Table UnityTable;
    private Table UnityTableEvent;

    private Table Timer;
    
    private Dictionary<int, Dictionary<string, List<DynValue>>> luaEventData = new();
            
    public List<IUpdate> UpdateHelper = new List<IUpdate>();
    public Dictionary<int, LuaObject> luaObject = new(); 
    public Dictionary<int, Transform> luaTransform = new();
    public Dictionary<int, Sprite> luaSprite = new();
    public Dictionary<int, AudioClip> luaAudioClip = new();

    public Dictionary<int,LuaTransformMove> luaTransformMove = new();
    public Dictionary<int,LuaTransformRot> luaTransformRot = new();

    public Dictionary<string, DynValue> luaSocketIOCallBack = new();

    private float fpsLua = 20;
    private float _timeRunLua;
    [SerializeField]
    [OnValueChanged("pareToLuaFile")]
    private List<string> modulesfile = new List<string>();
    [SerializeField]
    private string InitializerFile;

#if !UNTY_BUILD_RELEASE
    private string HttpLuaFile => "";
#endif

#if UNITY_DEVELOPMENT
    private string HttpLuaFile => RemoteConfigManager.GetValue(FirebaseKey.LuaPathDev);
#elif UNITY_RELEASE
    private string HttpLuaFile => RemoteConfigManager.GetValue(FirebaseKey.LuaPathRelease); 
#endif
    private KeyCode[] keyCodes;
    private bool isInstall;
    private string luaScriptText;

#if !UNTY_BUILD_RELEASE
    public static string assetFile = "Assets/Own/Luascript/";
#else
    private static string assetFile;
#endif
#region Lua module
    private void Awake()
    {
#if UNTY_BUILD_RELEASE
        assetFile = Path.Combine(Application.persistentDataPath , "bin/build.dat");
        if(!Directory.Exists(Path.Combine(Application.persistentDataPath, "bin")))
        {
            Directory.CreateDirectory(Path.Combine(Application.persistentDataPath, "bin"));
        }
#endif
        Instance = this;
    }

    [Button]
    public void pareToLuaFile()
    {
        string s = "return {\n";
        foreach (string key in modulesfile)
        {
            if(key != "modules/require")
            {
                s += "\t\"" + key + "\",\n";
            }
        }
        s += "}";
        File.WriteAllText(Application.dataPath + "\\Own\\Luascript\\modules\\main.lua", s);
        Debug.Log("file pare");
    }

    [Button]
    public void Resets()
    {
        Destroy(gameObject);
        Instantiate(gameObject);
    }
    public void Install()
    {        
        if(!isInstall)
        {
            RegisterUpdate();                
            UserData.RegisterType<APIGameObject>();
            UserData.RegisterType<APITransfrom>();
            UserData.RegisterType<APIRectTransform>();
            UserData.RegisterType<APISpriteRenderer>();
            UserData.RegisterType<APIImage>();
            UserData.RegisterType<APIText>();
            UserData.RegisterType<APITextMeshProGUI>();
            UserData.RegisterType<APIInputField>();
            UserData.RegisterType<APISlider>();
            UserData.RegisterType<APIButton>();
            UserData.RegisterType<APILeanTween>();
            UserData.RegisterType<APILTDescr>();
            UserData.RegisterType<APISocketIO>();
            UserData.RegisterType<APIDataLocalManager>();
            UserData.RegisterType<APIPopupManager>();
            UserData.RegisterType<APISceneLoader>();
            UserData.RegisterType<APIFSMC_Executer>();        
            UserData.RegisterType<APIFirebaseRemoteConfig>();        
            UserData.RegisterType<APIAudioSource>();        
            UserData.RegisterType<APISkeletonGraphic>();        
            UserData.RegisterType<APIToggle>();        
            UserData.RegisterType<APITextMeshPro>();        
            UserData.RegisterType<APIVisualScripting>();        
            UserData.RegisterType<APIFile>();        
            UserData.RegisterType<APISprite>();        
            UserData.RegisterType<APITMP_InputField>();        
            UserData.RegisterType<APIInAppPurchase>();        
            UserData.RegisterType<APIScreen>();        
            UserData.RegisterType<APILuaEvent>();        
            keyCodes = (KeyCode[])Enum.GetValues(typeof(KeyCode));
            // Khởi tạo đối tượng Script
            luaScript = new Script();
        }
        else
        {
            luaScript.Globals.Clear();
            luaScript = new Script();
        }
        UnityTable = new Table(luaScript);        
        UnityTableEvent = new Table(luaScript);
        // Thực thi mã Lua từ một xâu ký tự
        luaScript.Globals["print"] = (Action<object[]>)Print;    
        SetUnityTable();
        SetUnityTableEvent();
        luaScript.Globals["Unity"] = UnityTable;
        luaScript.Globals["UnityEvent"] = UnityTableEvent;

        luaScript.Globals["APIGameObject"] = typeof(APIGameObject);
        luaScript.Globals["APITransfrom"] = typeof(APITransfrom);
        luaScript.Globals["APIRectTransform"] = typeof(APIRectTransform);
        luaScript.Globals["APISpriteRenderer"] = typeof(APISpriteRenderer);
        luaScript.Globals["APIImage"] = typeof(APIImage);
        luaScript.Globals["APIText"] = typeof(APIText);
        luaScript.Globals["APITextMeshProGUI"] = typeof(APITextMeshProGUI);
        luaScript.Globals["APIInputField"] = typeof(APIInputField);
        luaScript.Globals["APISlider"] = typeof(APISlider);
        luaScript.Globals["APIButton"] = typeof(APIButton);
        luaScript.Globals["APILeanTween"] = typeof(APILeanTween);
        luaScript.Globals["APILTDescr"] = typeof(APILTDescr);
        luaScript.Globals["APISocketIO"] = typeof(APISocketIO);
        luaScript.Globals["APIDataLocalManager"] = typeof(APIDataLocalManager);
        luaScript.Globals["APIPopupManager"] = typeof(APIPopupManager);
        luaScript.Globals["APISceneLoader"] = typeof(APISceneLoader);
        luaScript.Globals["APIFSMC_Executer"] = typeof(APIFSMC_Executer);
        luaScript.Globals["APIFirebaseRemoteConfig"] = typeof(APIFirebaseRemoteConfig);
        luaScript.Globals["APIAudioSource"] = typeof(APIAudioSource);
        luaScript.Globals["APISkeletonGraphic"] = typeof(APISkeletonGraphic);
        luaScript.Globals["APIToggle"] = typeof(APIToggle);
        luaScript.Globals["APITextMeshPro"] = typeof(APITextMeshPro);
        luaScript.Globals["APIVisualScripting"] = typeof(APIVisualScripting);
        luaScript.Globals["APIFile"] = typeof(APIFile);
        luaScript.Globals["APISprite"] = typeof(APISprite);
        luaScript.Globals["APITMP_InputField"] = typeof(APITMP_InputField);
        luaScript.Globals["APIInAppPurchase"] = typeof(APIInAppPurchase);
        luaScript.Globals["APIScreen"] = typeof(APIScreen);
        luaScript.Globals["APILuaEvent"] = typeof(APILuaEvent);


        CancelInvoke("UpdateLua");
        InvokeRepeating("UpdateLua", 0, 1/fpsLua);

        // run file lua script
        try
        {
#if !UNTY_BUILD_RELEASE
            // set modules
            foreach (var module in modulesfile)
            {
                DoString(LoadAsset(module), null, module.Replace('/', '.'));
            }
            DoString(LoadAsset(InitializerFile), null, InitializerFile.Replace('/', '.'));
            Timer = luaScript.Globals.Get("Time").Table;
#else
            LoadLuaCodeFromHttp();
#endif
            
        }
        catch (ScriptRuntimeException ex)
        {            
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
#if !UNTY_BUILD_RELEASE
        DataManager data = new DataManager();
        isInstall = true;
        LeanTween.delayedCall(0.1f, () =>
        {
            EventManager.onLuaScriptLoadDone?.Invoke();
        });
#endif
    }    

    private void UpdateLua()
    {
        if (!isInstall) return;
        try
        {
            Timer["deltaTime"] = Math.Max(1f / fpsLua, Time.deltaTime);
            Timer.Get("tick").Function.CallFunction();
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }        
    }

    private bool holdingDown;
    private void Update()
    {
        if(!isInstall) return;
        try
        {
            if (Input.anyKeyDown)
            {
                KeyCode key = GetPressedKey();
                if (key != KeyCode.None)
                {
                    var @event = GetGlobal("Event");
                    @event.Table.Get("Emit").Function.CallFunction(@event, "KEY_DOWN", (int)GetPressedKey());
                }
            }

            if (Input.anyKey)
            {
                KeyCode key = GetPressedKey();
                if (key != KeyCode.None)
                {
                    var @event = GetGlobal("Event");
                    @event.Table.Get("Emit").Function.CallFunction(@event, "KEY_PRESSED", (int)GetPressedKey());
                }
            }

            if (Input.anyKey)
            {
                holdingDown = true;
            }

            if (!Input.anyKey && holdingDown)
            {
                KeyCode key = GetPressedKey();
                if (key != KeyCode.None)
                {
                    var @event = GetGlobal("Event");
                    @event.Table.Get("Emit").Function.CallFunction(@event, "KEY_UP", (int)GetPressedKey());
                }
                holdingDown = false;
            }
            #region Mount Down
            if (Input.GetMouseButtonDown(0))
            {
                Table table = CreateTable();
                table["code"] = 0;
                // Lấy vị trí của chuột
                Vector3 mousePosition = Input.mousePosition;

                // Chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
                mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
                table["position"] = GetGlobal("Vector3").Table.Get("new").Function.CallFunction(mousePosition.x, mousePosition.y, mousePosition.z);
                var @event = GetGlobal("Event");
                @event.Table.Get("Emit").Function.CallFunction(@event, "MOUSE_DOWN", table);
            }

            if (Input.GetMouseButtonDown(1))
            {
                Table table = CreateTable();
                table["code"] = 1;
                // Lấy vị trí của chuột
                Vector3 mousePosition = Input.mousePosition;

                // Chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
                mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
                table["position"] = GetGlobal("Vector3").Table.Get("new").Function.CallFunction(mousePosition.x, mousePosition.y, mousePosition.z);
                var @event = GetGlobal("Event");
                @event.Table.Get("Emit").Function.CallFunction(@event, "MOUSE_DOWN", table);
            }

            if (Input.GetMouseButtonDown(2))
            {
                Table table = CreateTable();
                table["code"] = 2;
                // Lấy vị trí của chuột
                Vector3 mousePosition = Input.mousePosition;

                // Chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
                mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
                table["position"] = GetGlobal("Vector3").Table.Get("new").Function.CallFunction(mousePosition.x, mousePosition.y, mousePosition.z);
                var @event = GetGlobal("Event");
                @event.Table.Get("Emit").Function.CallFunction(@event, "MOUSE_DOWN", table);
            }
            #endregion

            #region Mouse Up
            if (Input.GetMouseButtonUp(0))
            {
                Table table = CreateTable();
                table["code"] = 0;
                // Lấy vị trí của chuột
                Vector3 mousePosition = Input.mousePosition;

                // Chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
                mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
                table["position"] = GetGlobal("Vector3").Table.Get("new").Function.CallFunction(mousePosition.x, mousePosition.y, mousePosition.z);
                var @event = GetGlobal("Event");
                @event.Table.Get("Emit").Function.CallFunction(@event, "MOUSE_UP", table);
            }

            if (Input.GetMouseButtonUp(1))
            {
                Table table = CreateTable();
                table["code"] = 1;
                // Lấy vị trí của chuột
                Vector3 mousePosition = Input.mousePosition;

                // Chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
                mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
                table["position"] = GetGlobal("Vector3").Table.Get("new").Function.CallFunction(mousePosition.x, mousePosition.y, mousePosition.z);
                var @event = GetGlobal("Event");
                @event.Table.Get("Emit").Function.CallFunction(@event, "MOUSE_UP", table);
            }

            if (Input.GetMouseButtonUp(2))
            {
                Table table = CreateTable();
                table["code"] = 2;
                // Lấy vị trí của chuột
                Vector3 mousePosition = Input.mousePosition;

                // Chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
                mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
                table["position"] = GetGlobal("Vector3").Table.Get("new").Function.CallFunction(mousePosition.x, mousePosition.y, mousePosition.z);
                var @event = GetGlobal("Event");
                @event.Table.Get("Emit").Function.CallFunction(@event, "MOUSE_UP", table);
            }
            #endregion
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }

        foreach(var update in UpdateHelper)
        {
            update.OnUpdate();
        }
        
    }

    private void OnDestroy()
    {
        DataManager.Instance.Save();
    }

    private void OnApplicationQuit()
    {
        DataManager.Instance.Save();
    }

    public static void ExecuteFuntion(DynValue luaObject, string funtion, params object[] param)
    {
        try
        {
            GetGlobal("Lib").Table.Get("ExecuteFunction").Function.CallFunction(luaObject, funtion, param);
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
    }

    private void RegisterUpdate()
    {
        UpdateHelper.Add(new UpdateLuaTransfrom());      
    }

    private KeyCode GetPressedKey()
    {
        foreach (KeyCode keyCode in keyCodes)
        {
            if (Input.GetKeyDown(keyCode))
            {
                return keyCode;
            }
        }
        return KeyCode.None;
    }

    public static DynValue DoString(string code, Table globalContext = null, string codeFriendlyName = null)
    {
        return luaScript.DoString(code, globalContext, codeFriendlyName);
    }

    public static DynValue GetGlobal(string key)
    {
        return luaScript.Globals.Get(key);
    }

    public static Table CreateTable()
    {
        return new Table(luaScript);
    }

    private void SetUnityTable()
    {
#if !UNTY_BUILD_RELEASE
        UnityTable["IsEditor"] = true;
#endif
#if UNITY_ANDROID
        UnityTable["IsAndroid"] = true;
#endif
#if UNITY_PC
        UnityTable["IsPC"] = true;
#endif
#if !UNTY_BUILD_RELEASE
        UnityTable["require"] =(Func<string, DynValue>)Require; 
#endif
#if !UNTY_BUILD_RELEASE
        UnityTable["ReCompile"] = (Func<string, DynValue>)ReCompile;
#endif
        UnityTable["SocketIOHttp"] = (Action<string, Table ,DynValue, DynValue>)LuaSocketIOHttp;
        UnityTable["Logout"] = (Action)Logout;
        UnityTable["ReLoad"] = (Action)ReLoad;
        UnityTable["CopyText"] = (Action<string>)CopyText;
    }

    private void SetUnityTableEvent()
    {
        UnityTableEvent["RegiterEvent"] = (Action<int, string, DynValue>)UnityEvent_RegiterEvent;
        UnityTableEvent["UnRegiterEvent"] = (Action<int, string, DynValue>)UnityEvent_UnRegiterEvent;
        UnityTableEvent["RemoveInstanceID"] = (Action<int>)UnityEvent_RemoveInstanceID;        
    }

#endregion
    #region UnityTableEvent
    public void UnityEvent_RegiterEvent(int InstanceID, string eventName, DynValue func)
    {
        if(func.Type == DataType.Function)
        {
            if(!luaEventData.ContainsKey(InstanceID))
            {
                luaEventData.Add(InstanceID, new Dictionary<string, List<DynValue>>());
            }

            if (!luaEventData[InstanceID].ContainsKey(eventName))
            {
                luaEventData[InstanceID].Add(eventName, new List<DynValue>());
            }

            luaEventData[InstanceID][eventName].Add(func);
        }
    }

    public void UnityEvent_UnRegiterEvent(int InstanceID, string eventName, DynValue func)
    {
        if (func.Type == DataType.Function)
        {
            if (!luaEventData.ContainsKey(InstanceID))
            {
                return;
            }

            if (!luaEventData[InstanceID].ContainsKey(eventName))
            {
                return;
            }            
            luaEventData[InstanceID][eventName].Remove(func);
        }
    }

    public void UnityEvent_Emit(DynValue obj,int InstanceID, string eventName, params object[] @params)
    {
        if(luaEventData.ContainsKey(InstanceID) && luaEventData[InstanceID].ContainsKey(eventName))
        {
            foreach(var func in luaEventData[InstanceID][eventName])
            {
                try
                {
                    func.Function.CallFunction(obj, @params);

                }
                catch (ScriptRuntimeException ex)
                {
                    Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
                }
            }
        }
    }

    public void UnityEvent_RemoveInstanceID(int InstanceID)
    {
        luaEventData.Remove(InstanceID);
    }
    #endregion

    #region JsonModule
    public static string JsonEncode(Table table)
    {
        Table json = GetGlobal("Json").Table;
        return json.Get("encode").Function.CallFunction(table).String;
    }

    public static Table JsonDecode(string json)
    {
        Table luaJson = GetGlobal("Json").Table;
        return luaJson.Get("decode").Function.CallFunction(json).Table;
    }
    #endregion
    #region LuaObject
    public void LuaObjectAddLuaObject(int InstanceID, UnityEngine.Component component)
    {
        LuaObjectAddLuaGameObject(component.gameObject);

        LuaObject luaObject = this.luaObject[component.gameObject.GetInstanceID()];
        if (!luaObject.components.ContainsKey(InstanceID))
        {
            luaObject.components.Add(InstanceID, component);
        }

    }

    public void LuaObjectAddLuaGameObject(GameObject gameObject)
    {
        int GameObjectInstanceID = gameObject.GetInstanceID();
        if (!this.luaObject.ContainsKey(GameObjectInstanceID))
        {
            if(gameObject.scene.name != null)
            {
                OnDestroyDispatcher onDestroyDispatcher = gameObject.GetOrAddComponent<OnDestroyDispatcher>();
                onDestroyDispatcher.OnObjectDestroyed = (obj) => StartCoroutine(RemoveGameObject(obj));
            }
            this.luaObject.Add(GameObjectInstanceID, new LuaObject()
            {
                gameObject = gameObject.gameObject
            });
            LuaTransformAddTransform(gameObject.transform.GetInstanceID(), gameObject.transform);
        }
    }

    public IEnumerator RemoveGameObject(GameObject gameObject)
    {
        int GameObjectInstanceID = gameObject.GetInstanceID();
        int TransInstanceID = gameObject.transform.GetInstanceID();        
        yield return new WaitForSeconds(1);
        luaObject.Remove(GameObjectInstanceID);
        luaTransform.Remove(TransInstanceID);        
    }

    public UnityEngine.Component LuaObjectGetLuaComponent(int InstanceIDGameObject, int InstanceIDComponent)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject))
        {
            if (luaObject[InstanceIDGameObject].components.ContainsKey(InstanceIDComponent))
            {
                return luaObject[InstanceIDGameObject].components[InstanceIDComponent];
            }
        }
        return null;
    }

    #endregion

    #region LuaTransform
    public void LuaTransformAddTransform(int InsTransform, Transform transform)
    {
        if (!luaTransform.ContainsKey(InsTransform))
        {            
            luaTransform.Add(InsTransform, transform);
            LuaObjectAddLuaGameObject(transform.gameObject);
        }
    }
    #endregion
    #region LuaAsset
    public void AddLuaSprite(Sprite sprite)
    {
        if(sprite != null)
        {
            if (!luaSprite.ContainsKey(sprite.GetInstanceID()))
            {
                luaSprite.Add(sprite.GetInstanceID(), sprite);
            }
        }
    }

    public void AddLuaAudioClip(AudioClip audioClip)
    {
        if (audioClip != null)
        {
            if (!luaAudioClip.ContainsKey(audioClip.GetInstanceID()))
            {
                luaAudioClip.Add(audioClip.GetInstanceID(), audioClip);
            }
        }
    }
    #endregion

    #region Socket IO

    private void LuaSocketIOHttp(string uri, Table data, DynValue callBack, DynValue callBackError)
    {        
        uri =  DataCsManager.Instance.server + uri;

        SocketManager.Instance.SendHTTP(uri, JsonEncode(data), (resp) =>
        {
            callBack.Function.CallFunction(resp);
        }, (resp, err) =>
        {
            callBackError.Function.CallFunction(resp, err);
        });
    }

    private void Logout()
    {
        DataCsManager.Instance.loginData = null;
        SocketManager.Instance.Disconnected();
        EventManager.onLogout?.Invoke();
    }

    private void ReLoad()
    {
        SceneLoader.Instance.LoadData();
        SceneLoader.Instance.SetValue(0, false);
        LeanTween.delayedCall(0.2f, () =>
        {
            EventManager.onReLoad?.Invoke();
        });
        LeanTween.delayedCall(0.4f, () =>
        {
            Install();
        });
    }



    #endregion
    #region Unity Helper
    private void CopyText(string text)
    {        
        GUIUtility.systemCopyBuffer = text;        
    }
    #endregion
#if !UNTY_BUILD_RELEASE
    private DynValue ReCompile(string path)
    {
        string luaCode = $"local __path = '{path}';" + File.ReadAllText(assetFile + path);
        return luaScript.DoString(luaCode, null, path);
    }
#endif

    public Vector3 ConvertTableToVector3(Table vector3)
    {
        return new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
    }
    
    public Vector3 ConvertTableToVector2(Table vector3)
    {
        return new Vector2(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number));
    }

    public Quaternion ConvertTableToQuaternion(Table vector3)
    {
        return new Quaternion(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number), Convert.ToSingle(vector3.Get("w").Number));
    }

    public Table ConvertQuaternionToTable(Quaternion quaternion)
    {
        Table table = CreateTable();
        table["x"] = quaternion.x;
        table["y"] = quaternion.y;
        table["z"] = quaternion.z;
        table["w"] = quaternion.w;
        return table;
    }

    public Table ConvertV2ToTable(Vector2 vector2)
    {
        Table table = CreateTable();
        table["x"] = vector2.x;
        table["y"] = vector2.y;        
        return table;
    }

    public Table ConvertV3ToTable(Vector3 vector3)
    {
        Table table = CreateTable();
        table["x"] = vector3.x; 
        table["y"] = vector3.y; 
        table["z"] = vector3.z;
        return table;
    }

    public Table ConvertRectToTable(Rect rect)
    {
        Table table = CreateTable();
        table["x"] = rect.x;
        table["y"] = rect.y;
        table["width"] = rect.width;
        table["height"] = rect.height;
        return table;
    }    

    public Color ConverTableToColor(Table table)
    {
        return new Color(Convert.ToSingle(table.Get("r").Number), Convert.ToSingle(table.Get("g").Number), Convert.ToSingle(table.Get("b").Number), Convert.ToSingle(table.Get("a").Number));
    }
    
    public Table ConverColorToTable(Color color)
    {
        Table table = CreateTable();
        table["r"] = color.r;
        table["g"] = color.g;
        table["b"] = color.b;
        table["a"] = color.a;
        return table;
    }

    public DynValue Require(string path)
    {
        try
        {
            string filePath = "lua/" + path.Replace('.', '/');
            string luaCode = $"local __path = '{filePath}.lua';"+LoadAsset(filePath);
            return luaScript.DoString(luaCode, null, path);

        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
            return null;
        }
    }

    private void Print(params object[] strs)
    {
        string[] log = new string[strs.Length];
        for(int i =0; i < log.Length; i++)
        {
            log[i] = Convert.ToString(strs[i]);
        }
#if UNITY_EDITOR
        CustomLogger.Log(string.Join('\t', log),1);
#else
        Debug.Log(string.Join('\t', log));    
#endif
    }

    private void Error(string str)
    {
#if UNITY_EDITOR
        CustomLogger.Log(str,2);
#else
        Debug.LogError(str);
#endif
        
    }

    public static string LoadAsset(string path)
    {
        string data = File.ReadAllText(assetFile + path + ".lua");
        return data;
    }

    public static string DecodeLua(string path)
    {
        return "";
    }


    private void LoadLuaCodeFromHttp()
    {
        if (string.IsNullOrEmpty(luaScriptText))
        {
            StartCoroutine(LoadFileLua());
        }
        else
        {
            LoadLuaFormServer(luaScriptText);
        }
    }

    private IEnumerator LoadFileLua()
    {
        if (CheckSum())
        {
            string text = File.ReadAllText(assetFile);
            LoadLuaFormServer(text);
        }
        else
        {
            bool isSuccess = false;
            StoreManager.Instance.Read(HttpLuaFile, (txt) =>
            {
                isSuccess = true;
                luaScriptText = txt;
            });
            yield return new WaitUntil(() => isSuccess);        
            File.WriteAllText(assetFile, luaScriptText);
            LoadLuaFormServer(luaScriptText);
        }
    }

    public bool CheckSum()
    {
        if (!File.Exists(assetFile))
        {
            return false;
        }
        string checkSum = AssetBundleManager.GenerateSHA256ChecksumForFile(assetFile);
        return checkSum == RemoteConfigManager.GetValue(FirebaseKey.LuaCheckSum);
    }

    public string DecryptLuaScript(string luatext)
    {
        int[] enkey = { 36, 48, 43, 112, 101, 105, 67, 89, 75, 83, 79, 38, 85, 74, 81, 90, 89, 94, 120, 83, 98, 33, 65, 85, 106, 70, 51, 79, 101, 79, 77, 76 };
        byte[] key = new byte[enkey.Length];
        for (int i = 0; i < enkey.Length; i++)
        {
            key[i] = Convert.ToByte(enkey[i]);
        }
        byte[] iv = { 50, 135, 251, 183, 12, 14, 254, 193, 24, 121, 132, 152, 204, 141, 211, 119 };
        byte[] cipherText = Convert.FromBase64String(luatext);
        return EncryptionHelper.Decrypt(cipherText, key, iv);
    }

    private void LoadLuaFormServer(string text)
    {
        try
        {
            luaScriptText = text;
            string luaScript = DecryptLuaScript(luaScriptText);
            DoString(luaScript);

        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage + "\n" + ex.StackTrace);
        }
        Timer = luaScript.Globals.Get("Time").Table;
        DataManager data = new DataManager();
        isInstall = true;
        LeanTween.delayedCall(0.1f, () =>
        {
            EventManager.onLuaScriptLoadDone?.Invoke();
        });
        Debug.Log("Get Completed");
    }
    
    public bool CheckScript(DynValue dynValue)
    {
        if (dynValue == null)
        {
            return false;
        }
        return dynValue.Table.OwnerScript == luaScript;
    }

#if UNITY_EDITOR
    private void OnGUI()
    {
        // Thiết lập vị trí và kích thước của nút
        float buttonWidth = 100;
        float buttonHeight = 50;
        float buttonX = Screen.width - buttonWidth - 10; // 10 pixels from the right edge
        float buttonY = 10; // 10 pixels from the top edge

        // Tạo nút và kiểm tra xem có nhấn vào không
        if (GUI.Button(new Rect(buttonX, buttonY, buttonWidth, buttonHeight), "Reload"))
        {
            ReLoad();            
        }
    }
#endif
}