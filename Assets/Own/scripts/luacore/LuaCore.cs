using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Serialization.Json;
using SocketIOClient;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LuaObject
{
    public GameObject gameObject;
    public Dictionary<int, UnityEngine.Component> components = new();
}

public struct LuaTransformMove
{
    public Transform transform;
    public Vector3 posMove;
}

public struct LuaTransformRot
{
    public Transform transform;
    public Vector3 rotMove;
}

public class LuaCore : MonoBehaviour
{
    public static LuaCore Instance;
    private static Script luaScript;
    private Table UnityTable;
    private Table UnityTableEvent;

    private Table Timer;
    
    private Dictionary<int, Dictionary<string, List<DynValue>>> luaEventData = new();
            
    private Dictionary<int, LuaObject> luaObject = new(); 
    private Dictionary<int, Transform> luaTransform = new();
    private Dictionary<int, Sprite> luaSprite = new();

    private Dictionary<int,LuaTransformMove> luaTransformMove = new();
    private Dictionary<int,LuaTransformRot> luaTransformRot = new();

    private Dictionary<string, DynValue> luaSocketIOCallBack = new();

    private float fpsLua = 20;
    private float _timeRunLua;
    [SerializeField]
    private List<string> modulesfile = new List<string>();

#if UNITY_EDITOR
    public static string assetFile = "Assets/Resources/Luascript/";
#else
    private static string assetFile = Application.persistentDataPath + "Luascript/";
#endif
    #region Lua module
    public void Awake()
    {                
        Instance = this;
        // Khởi tạo đối tượng Script
        luaScript = new Script();
        UnityTable = new Table(luaScript);        
        UnityTableEvent = new Table(luaScript);
        // Thực thi mã Lua từ một xâu ký tự
        luaScript.Globals["print"] = (Action<object[]>)Print;
        luaScript.Globals["error"] = (Action<string>)Error;        
        SetUnityTable();
        SetUnityTableEvent();
        luaScript.Globals["Unity"] = UnityTable;
        luaScript.Globals["UnityEvent"] = UnityTableEvent;

        SetModulesJsonParser();


        // run file lua script
        try
        {
            // set modules
            foreach (var module in modulesfile)
            {            
                DoString(LoadAsset(module), null, module.Replace('/','.'));
            }

            Timer = luaScript.Globals.Get("Time").Table;
        }
        catch (ScriptRuntimeException ex)
        {            
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
        }
        catch (Exception ex)
        {            
            Debug.LogError("An error occurred: " + ex.Message);
        }

        StartCoroutine(LuaSocketIOInit());
        DontDestroyOnLoad(gameObject);
        SceneManager.LoadScene(1);        
    }

    
    private void Update()
    {
        try
        {
            if (_timeRunLua <= 0)
            {
                Timer["deltaTime"] = Math.Max(1f/fpsLua, Time.deltaTime);
                Timer.Get("tick").Function.Call();
                _timeRunLua = 1f / fpsLua - _timeRunLua;
            }
            else
            {
                _timeRunLua -= Time.deltaTime;
            }
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
        }

        LuaTransformUpdate();
        LuaSocketUpdate();
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
    private void SetModulesJsonParser()
    {
        Table json = new Table(luaScript);

        json["encode"] = (Func<Table, string>)JsonEncode;
        json["decode"] = (Func<string, Table>)JsonDecode;

        luaScript.Globals["Json"] = json;
    }

    private void SetUnityTable()
    {
#if UNITY_EDITOR
        UnityTable["IsEditor"] = true;
#endif
#if UNITY_ANDROID
        UnityTable["IsAndroid"] = true;
#endif
#if UNITY_PC
        UnityTable["IsPC"] = true;
#endif
        UnityTable["require"] =(Func<string, DynValue>)Require; 
        UnityTable["DestroyObject"] =(Action<int>)LuaObjectDestroyLuaObject;
        UnityTable["DestroyComponent"] =(Action<int, int>)LuaObjectDestroyLuaComponent;
        UnityTable["SetEnableComponent"] =(Action<int, int, bool>)LuaObjectSetLuaComponentEnable;
        UnityTable["SetObjectActive"] =(Action<int, bool>)LuaObjectSetLuaObjectActive;
        UnityTable["AddComponent"] = (Func<int, string, DynValue>)LuaObjectAddLuaComponent;
        UnityTable["InstantiateLuaObject"] = (Func<int, DynValue>)LuaObjectInstantiateLuaObject;
        UnityTable["TransformSetPosition"] = (Action<int, Table>)LuaTransformSetPosition;
        UnityTable["TransformMove"] = (Action<int, Table>)LuaTransformMove;
        UnityTable["TransformStopMove"] = (Action<int>)LuaTransformStopMove;
        UnityTable["TransformGetPosition"] = (Func<int, Table>)LuaTransformGetPosition;
        UnityTable["TransformGetLocalPosition"] = (Func<int, Table>)LuaTransformGetLocalPosition;
        UnityTable["TransformSetLocalPosition"] = (Action<int, Table>)LuaTransformSetLocalPosition;
        UnityTable["TransformGetRotation"] = (Func<int, Table>)LuaTransformGetRotation;
        UnityTable["TransformSetRotation"] = (Action<int, Table>)LuaTransformSetRotation;
        UnityTable["TransformSetSmootRote"] = (Action<int, Table>)LuaTransformSetSmootRote;
        UnityTable["TransformStopSmootRote"] = (Action<int>)LuaTransformStopSmootRote;
        UnityTable["TransformGetChildCount"] = (Func<int, int>)LuaTransformGetChildCount;
        UnityTable["TransformGetChild"] = (Func<int, int, Table>)LuaTransformGetChild;
        UnityTable["LuaTransformGetAllChild"] = (Func<int, Table>)LuaTransformGetAllChild;
        UnityTable["UISetImage"] = (Action<int, int, int>)LuaUISetImage;
        UnityTable["UISetText"] = (Action<string, int, int>)LuaUISetText;
        UnityTable["UISetTextMeshPro"] = (Action<string, int, int>)LuaUISetTextMeshPro;
        UnityTable["UISetSliderValue"] = (Action<float, int, int>)LuaUISetSliderValue;
        UnityTable["UISetMinSliderValue"] = (Action<float, int, int>)LuaUISetMinSliderValue;
        UnityTable["UISetMaxSliderValue"] = (Action<float, int, int>)LuaUISetMaxSliderValue;
        UnityTable["UISmootSliderValue"] = (Action<int, int, float, float, int, DynValue>)LuaUISmootSliderValue;
        UnityTable["UIScrollBarSetValue"] = (Action<float, int, int>)LuaUIScrollBarSetValue;
        UnityTable["UISmootScrollBaValue"] = (Action<int, int, float, float, int, DynValue>)LuaUISmootScrollBaValue;
        UnityTable["LeanTweenMove"] = (Func<int, Table, float, int>)LuaLeanTweenMove;
        UnityTable["LeanTweenLocalMove"] = (Func<int, Table, float, int>)LuaLeanTweenLocalMove;
        UnityTable["LeanTweenScale"] = (Func<int, Table, float, int>)LuaLeanTweenScale;
        UnityTable["LeanTweenRotate"] = (Func<int, Table, float, int>)LuaLeanTweenRotate;
        UnityTable["LeanTweenMoveX"] = (Func<int, float, float, int>)LuaLeanTweenMoveX;
        UnityTable["LeanTweenMoveY"] = (Func<int, float, float, int>)LuaLeanTweenMoveY;
        UnityTable["LeanTweenMoveZ"] = (Func<int, float, float, int>)LuaLeanTweenMoveZ;        
        UnityTable["LeanTweenLocalMoveX"] = (Func<int, float, float, int>)LuaLeanTweenLocalMoveX;
        UnityTable["LeanTweenLocalMoveY"] = (Func<int, float, float, int>)LuaLeanTweenLocalMoveY;
        UnityTable["LeanTweenLocalMoveZ"] = (Func<int, float, float, int>)LuaLeanTweenLocalMoveZ;
        UnityTable["LeanTweenScaleX"] = (Func<int, float, float, int>)LuaLeanTweenScaleX;
        UnityTable["LeanTweenScaleY"] = (Func<int, float, float, int>)LuaLeanTweenScaleY;
        UnityTable["LeanTweenScaleZ"] = (Func<int, float, float, int>)LuaLeanTweenScaleZ;
        UnityTable["LeanTweenRotateX"] = (Func<int, float, float, int>)LuaLeanTweenRotateX;
        UnityTable["LeanTweenRotateY"] = (Func<int, float, float, int>)LuaLeanTweenRotateY;
        UnityTable["LeanTweenRotateZ"] = (Func<int, float, float, int>)LuaLeanTweenRotateZ;
        UnityTable["ExecuteFunctionLTDescr"] = (Action<int, string, DynValue>)ExecuteFunctionLTDescr;
        UnityTable["SocketIOOn"] = (Action<string, DynValue>)LuaSocketIOOn;
        UnityTable["SocketIOSendMessage"] = (Action<string, Table ,DynValue>)LuaSocketIOSendMessage;
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
            Debug.Log("Co xoa");
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
                    func.Function.Call(obj, @params);

                }
                catch (ScriptRuntimeException ex)
                {
                    Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
                }
                catch (Exception ex)
                {
                    Debug.LogError("An error occurred: " + ex.Message);
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
    private string JsonEncode(Table table)
    {
        return JsonTableConverter.TableToJson(table);
    }

    private Table JsonDecode(string json)
    {
        return JsonTableConverter.JsonToTable(json);
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
            this.luaObject.Add(GameObjectInstanceID, new LuaObject()
            {
                gameObject = gameObject.gameObject
            });
        }
    }

    public GameObject LuaObjectGetLuaObject(int InstanceIDGameObject)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject))
        {
            return luaObject[InstanceIDGameObject].gameObject;
        }
        return null;
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

    public void LuaObjectDestroyLuaObject(int InstanceIDGameObject)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject))
        {
            luaTransform.Remove(luaObject[InstanceIDGameObject].gameObject.transform.GetInstanceID());
            UnityEvent_Emit(null, luaObject[InstanceIDGameObject].gameObject.GetInstanceID(), "GameObjectDestroy");
            Destroy(luaObject[InstanceIDGameObject].gameObject);
            luaObject.Remove(InstanceIDGameObject); 
        }
    }

    public void LuaObjectDestroyLuaComponent(int InstanceIDGameObject, int InstanceIDComponent)
    {
        UnityEngine.Component component = LuaObjectGetLuaComponent(InstanceIDGameObject, InstanceIDComponent);
        if (component != null)
        {
            Destroy(component);
            luaObject[InstanceIDGameObject].components.Remove(InstanceIDComponent);
        }
    }

    public void LuaObjectSetLuaComponentEnable(int InstanceIDGameObject, int InstanceIDComponent, bool enable)
    {
        UnityEngine.Component component = LuaObjectGetLuaComponent(InstanceIDGameObject, InstanceIDComponent);                                        
        MonoBehaviour monoBehaviour = (MonoBehaviour)component;
        monoBehaviour.enabled = enable;
        
    }

    public void LuaObjectSetLuaObjectActive(int InstanceIDGameObject, bool active)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject)) 
        {
            luaObject[InstanceIDGameObject].gameObject.SetActive(active);
        }
    }

    public DynValue LuaObjectAddLuaComponent(int InstanceIDGameObject, string nameClassLua)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject))
        {
            LuaScript luaScript = luaObject[InstanceIDGameObject].gameObject.AddComponent<LuaScript>();
            luaScript.classLua = nameClassLua;
            luaScript.isInitialized = true;
            luaScript.Awake();
            return luaScript.luaObject;
        }

        return null;
    }

    public DynValue LuaObjectInstantiateLuaObject(int InstanceIDGameObject)
    {
        GameObject gameObject = Instantiate(luaObject[InstanceIDGameObject].gameObject);
        LuaObjectAddLuaGameObject(gameObject);
        return GetGlobal("Lib").Table.Get("GetOrAddGameObject").Function.Call(gameObject.GetInstanceID());
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

    public Table LuaTransformGetPosition(int InsTransform)
    {
        Table table = new Table(luaScript);
        Transform transform = luaTransform[InsTransform];
        table["x"] = transform.position.x;
        table["y"] = transform.position.y;
        table["z"] = transform.position.z;
        return table;
    }

    public void LuaTransformSetPosition(int InsTransform, Table vector3)
    {
        if (luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            Transform transform = luaTransform[InsTransform];
            transform.position = pos;
        }
    }

    public Table LuaTransformGetLocalPosition(int InsTransform)
    {
        Table table = new Table(luaScript);
        Transform transform = luaTransform[InsTransform];
        table["x"] = transform.localPosition.x;
        table["y"] = transform.localPosition.y;
        table["z"] = transform.localPosition.z;
        return table;
    }

    public void LuaTransformSetLocalPosition(int InsTransform, Table vector3)
    {
        if (luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            Transform transform = luaTransform[InsTransform];
            transform.localPosition = pos;
        }
    }


    public void LuaTransformMove(int InsTransform, Table vector3)
    {
        if(luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            luaTransformMove.Add(InsTransform,new LuaTransformMove()
            {
                transform = luaTransform[InsTransform],
                posMove = pos
            });
        }
    }

    public void LuaTransformStopMove(int InsTransform)
    {
        luaTransformMove.Remove(InsTransform);
    }

    public void LuaTransformSetRotation(int InsTransform, Table quaternion)
    {
        if (luaTransform.ContainsKey(InsTransform))
        {
            Quaternion rot = new Quaternion(Convert.ToSingle(quaternion.Get("x").Number), Convert.ToSingle(quaternion.Get("y").Number), Convert.ToSingle(quaternion.Get("z").Number), Convert.ToSingle(quaternion.Get("w").Number));
            Transform transform = luaTransform[InsTransform];            
            transform.rotation = rot;
        }
    }

    public Table LuaTransformGetRotation(int InsTransform)
    {
        Table table = new Table(luaScript);
        Transform transform = luaTransform[InsTransform];
        table["x"] = transform.rotation.x;
        table["y"] = transform.rotation.y;
        table["z"] = transform.rotation.z;
        table["w"] = transform.rotation.w;
        return table;
    }

    public void LuaTransformSetSmootRote(int InsTransform, Table vector3)
    {
        if (luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));            
            luaTransformRot.Add(InsTransform, new LuaTransformRot()
            {
                transform = luaTransform[InsTransform],
                rotMove = pos
            });
        }
    }

    public void LuaTransformStopSmootRote(int InsTransform)
    {
        luaTransformRot.Remove(InsTransform);
    }

    public int LuaTransformGetChildCount(int InsTransform)
    {        
        Transform transform = luaTransform[InsTransform];
        return transform.childCount;
    }

    public Table LuaTransformGetChild(int InsTransform, int index)
    {
        Transform transform = luaTransform[InsTransform];
        Table table = CreateTable();
        table["transform"] = transform.GetChild(index).GetInstanceID();
        table["gameObject"] = transform.GetChild(index).gameObject.GetInstanceID();
        LuaTransformAddTransform(transform.GetChild(index).GetInstanceID(), transform.GetChild(index));
        return table;
    }

    public Table LuaTransformGetAllChild(int InsTransform)
    {
        Transform transform = luaTransform[InsTransform];
        Table table = CreateTable();        
        for(int i = 0; i < transform.childCount; i++)
        {
            Table table1 = CreateTable();
            table1["transform"] = transform.GetChild(i).GetInstanceID();
            table1["gameObject"] = transform.GetChild(i).gameObject.GetInstanceID();
            table[i + 1] = table1;
            LuaTransformAddTransform(transform.GetChild(i).GetInstanceID(), transform.GetChild(i));
        }
        return table;
    }

    public void LuaTransformUpdate()
    {
        foreach(var transform in luaTransformMove.Values)
        {            
            transform.transform.position += transform.posMove * Time.deltaTime;
        }

        foreach(var transform in luaTransformRot.Values)
        {
            transform.transform.Rotate(transform.rotMove * Time.deltaTime);
        }
    }
    #endregion

    #region LuaUI
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

    public void LuaUISetImage(int spriteID, int InstanceIDGameObject ,int InstanceIDComponent)
    {
        if(luaSprite.ContainsKey(spriteID))
        {
            Image image = (Image)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
            image.sprite = luaSprite[spriteID];
        }        
    }

    public void LuaUISetText(string text, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Text txt = (Text)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.text = text;
    }

    public void LuaUISetTextMeshPro(string text, int InstanceIDGameObject, int InstanceIDComponent)
    {
        TextMeshProUGUI txt = (TextMeshProUGUI)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        txt.text = text;
    }

    public void LuaUISetSliderValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        slider.value = value;
    }

    public void LuaUISetMinSliderValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        slider.minValue = value;
    }

    public void LuaUISetMaxSliderValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Slider slider = (Slider)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        slider.maxValue = value;
    }

    public void LuaUISmootSliderValue( int InstanceIDGameObject, int InstanceIDComponent, float toValue, float time, int leanTweenType, DynValue callback)
    {
        Slider slider = (Slider)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        LeanTween.value(slider.gameObject, slider.value, toValue, time).setEase((LeanTweenType)leanTweenType).setOnUpdate((float value) =>
        {
            slider.value = value;
        }).setOnComplete(() =>
        {
            if(callback.Type == DataType.Function)
            {
                callback.Function.Call();
            }
        });
    }

    public void LuaUIScrollBarSetValue(float value, int InstanceIDGameObject, int InstanceIDComponent)
    {
        Scrollbar scrollbar = (Scrollbar)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        scrollbar.value = value;
    }

    public void LuaUISmootScrollBaValue(int InstanceIDGameObject, int InstanceIDComponent, float toValue, float time, int leanTweenType, DynValue callback)
    {
        Scrollbar scrollbar = (Scrollbar)luaObject[InstanceIDGameObject].components[InstanceIDComponent];
        LeanTween.value(scrollbar.gameObject, scrollbar.value, toValue, time).setEase((LeanTweenType)leanTweenType).setOnUpdate((float value) =>
        {
            scrollbar.value = value;
        }).setOnComplete(() =>
        {
            if (callback.Type == DataType.Function)
            {
                callback.Function.Call();
            }
        });
    }

    #endregion

    #region Socket IO
    private class SocketIOOnResponses
    {
        public SocketIOResponse socketIOResponse; 
        public DynValue dynvalue;
    }

    private List<SocketIOResponse> socketIOResponses = new List<SocketIOResponse>();
    private List<SocketIOOnResponses> socketIOOnResponses = new List<SocketIOOnResponses>();


    private IEnumerator LuaSocketIOInit()
    {
        yield return new WaitUntil(() =>
        {
            return SocketManager.socket != null;
        });
        SocketManager.socket.On("__callBack", (res) =>
        {
            socketIOResponses.Add(res);
        });
    }

    private void LuaSocketUpdate()
    {
        // xử lý response            
        foreach (SocketIOResponse res in socketIOResponses)
        {
            Table table = JsonDecode(res.ToString()).Get(1).Table;
            string guid = table.Get("guid").String;
            Table data = table.Get("data").Table;
            if (luaSocketIOCallBack.ContainsKey(guid))
            {
                luaSocketIOCallBack[guid].Function.Call(data);
                luaSocketIOCallBack.Remove(guid);
            }
        }
        socketIOResponses.Clear();

        foreach(var res in socketIOOnResponses)
        {
            Table table = JsonDecode(res.socketIOResponse.ToString());
            res.dynvalue.Function.Call(table);
        }

        socketIOOnResponses.Clear();
    }

    private void LuaSocketIOOn(string @event, DynValue func)
    {
        SocketManager.socket.On(@event, (res) =>
        {
            socketIOOnResponses.Add(new SocketIOOnResponses()
            {
                socketIOResponse = res,
                dynvalue = func
            });
        });
    }

    private void LuaSocketIOSendMessage(string @event, Table message, DynValue func)
    {
        if(func != null && func.Type == DataType.Function)
        {
            string guid = Guid.NewGuid().ToString();
            message["__callBackGuid"] = guid;
            luaSocketIOCallBack.Add(guid, func);
        }

        string json = JsonEncode(message);
        SocketManager.socket.EmitAsync(@event,json);
    }

    #endregion

    #region LuaLeanTween

    private int LuaLeanTweenMove(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = ConvertTableToVector3(v3To);
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.move(gameObject, vector3, time);
        return tween.uniqueId;
    }


    private int LuaLeanTweenScale(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = ConvertTableToVector3(v3To);
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scale(gameObject, vector3, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenLocalMove(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = ConvertTableToVector3(v3To);
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocal(gameObject, vector3, time);
        return tween.uniqueId;
    }
    
    private int LuaLeanTweenRotate(int InsGameObject, Table v3To, float time)
    {
        Vector3 vector3 = ConvertTableToVector3(v3To);
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotate(gameObject, vector3, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenMoveX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenMoveY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenMoveZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenLocalMoveX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocalX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenLocalMoveY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocalY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenLocalMoveZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.moveLocalZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenScaleX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scaleX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenScaleY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scaleY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenScaleZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.scaleZ(gameObject, v3Z, time);
        return tween.uniqueId;
    }        
    
    private int LuaLeanTweenRotateX(int InsGameObject, float v3X, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotateX(gameObject, v3X, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenRotateY(int InsGameObject, float v3Y, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotateY(gameObject, v3Y, time);
        return tween.uniqueId;
    }

    private int LuaLeanTweenRotateZ(int InsGameObject, float v3Z, float time)
    {
        GameObject gameObject = luaObject[InsGameObject].gameObject;
        var tween = LeanTween.rotateZ(gameObject, v3Z, time);
        return tween.uniqueId;        
    }    

    private void ExecuteFunctionLTDescr(int tweenID,string functionName, DynValue value)
    {
        var tween = LeanTween.get(tweenID); 
        if(tween != null)
        {
            switch(functionName)
            {
                case "setOnComplete":
                    if(value != null && value.Type == DataType.Function)
                    {
                        tween.setOnComplete(() =>
                        {
                            value.Function.Call();
                        });
                    }
                    break;
                case "setEase":
                    if (value != null && value.Type == DataType.Number)
                    {
                        tween.setEase((LeanTweenType)value.Number);
                    }
                    break;
            }
        }
    }

    #endregion

    private Vector3 ConvertTableToVector3(Table vector3)
    {
        return new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
    }

    private Table ConvertV3ToTable(Vector3 vector3)
    {
        Table table = CreateTable();
        table["x"] = vector3.x; 
        table["y"] = vector3.y; 
        table["z"] = vector3.z;
        return table;
    }
    public DynValue Require(string path)
    {
        try
        {
            string luaCode = $"local __path = '{path}'"+LoadAsset("lua/" + path.Replace('.', '/'));
            return luaScript.DoString(luaCode, null, path);

        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
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
        
        Debug.Log(string.Join('\t', log));
    }

    private void Error(string str)
    {

        Debug.LogError(str);
    }

    public static string LoadAsset(string path)
    {
        string data = File.ReadAllText(assetFile + path + ".lua");
        return data;
    }


}
