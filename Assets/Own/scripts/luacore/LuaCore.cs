using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Serialization.Json;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using Unity.VisualScripting;
using Unity.VisualScripting.Antlr3.Runtime;
using UnityEngine;
using UnityEngine.SceneManagement;
using static UnityEditor.PlayerSettings;

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
    private List<Action> ActionUpdate = new List<Action>();
    private Dictionary<int, Dictionary<string, List<DynValue>>> luaEventData = new();
            
    private Dictionary<int, LuaObject> luaObject = new(); 
    private Dictionary<int, Transform> luaTransform = new();

    private Dictionary<int,LuaTransformMove> luaTransformMove = new();
    private Dictionary<int,LuaTransformRot> luaTransformRot = new();

    private float fpsLua = 20;
    private float _timeRunLua;
    private List<string> modulesfile = new List<string>()
    {
        "modules/require",
        "modules/Math",
        "modules/update",
        "modules/Lib",
        "modules/class",
        "modules/GameObject",
        "modules/Vector2",
        "modules/Vector3",
        "modules/Quaternion",
        "modules/Component",
        "modules/Transform",
        "modules/MonoBehaviour",
        "lua/RegisterClass"
    };

#if UNITY_EDITOR
    public static string assetFile = "Assets/Resources/Luascript/";
#else
    private static string assetFile = Application.persistentDataPath + "Luascript/";
#endif

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

        DontDestroyOnLoad(gameObject);
        SceneManager.LoadScene(1);
        ActionUpdate.Add(LuaTransformUpdate);
    }

    
    void Update()
    {
        try
        {
            if (_timeRunLua <= 0)
            {
                Timer["deltaTime"] = Math.Max(1f/fpsLua, Time.deltaTime);
                Timer.Get("tick").Function.Call();
                _timeRunLua = 1f / fpsLua;
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

        foreach(var action in ActionUpdate)
        {
            action.Invoke();
        }
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
        UnityTable["require"] =(Func<string, DynValue>)Require;
        UnityTable["DestroyObject"] =(Action<int>)DestroyLuaObject;
        UnityTable["DestroyComponent"] =(Action<int, int>)DestroyLuaComponent;
        UnityTable["SetEnableComponent"] =(Action<int, int, bool>)SetLuaComponentEnable;
        UnityTable["SetObjectActive"] =(Action<int, bool>)SetLuaObjectActive;
        UnityTable["AddComponent"] = (Func<int, string, DynValue>)AddLuaComponent;
        UnityTable["TransformSetPosition"] = (Action<int, Table>)LuaTransformSetPosition;
        UnityTable["TransformMove"] = (Action<int, Table>)LuaTransformMove;
        UnityTable["TransformStopMove"] = (Action<int>)LuaTransformStopMove;
        UnityTable["TransformGetPosition"] = (Func<int, Table>)LuaTransformGetPosition;
        UnityTable["TransformGetRotation"] = (Func<int, Table>)GetRotation;
        UnityTable["TransformSetRotation"] = (Action<int, Table>)SetRotation;
        UnityTable["TransformSetSmootRote"] = (Action<int, Table>)SetSmootRote;
        UnityTable["TransformStopSmootRote"] = (Action<int>)StopSmootRote;
    }

    private void SetUnityTableEvent()
    {
        UnityTableEvent["RegiterEvent"] = (Action<int, string, DynValue>)UnityEvent_RegiterEvent;
        UnityTableEvent["UnRegiterEvent"] = (Action<int, string, DynValue>)UnityEvent_UnRegiterEvent;
        UnityTableEvent["RemoveInstanceID"] = (Action<int>)UnityEvent_RemoveInstanceID;        
    }
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
    public void AddLuaObject(int InstanceID, UnityEngine.Component component)
    {
        int GameObjectInstanceID = component.gameObject.GetInstanceID();
        if (!this.luaObject.ContainsKey(GameObjectInstanceID))
        {
            this.luaObject.Add(GameObjectInstanceID, new LuaObject()
            {
                gameObject = component.gameObject
            });
        }

        LuaObject luaObject = this.luaObject[GameObjectInstanceID];
        if (!luaObject.components.ContainsKey(InstanceID))
        {
            luaObject.components.Add(InstanceID, component);
        }

    }

    public GameObject GetLuaObject(int InstanceIDGameObject)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject))
        {
            return luaObject[InstanceIDGameObject].gameObject;
        }
        return null;
    }

    public UnityEngine.Component GetLuaComponent(int InstanceIDGameObject, int InstanceIDComponent)
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

    public void DestroyLuaObject(int InstanceIDGameObject)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject))
        {
            luaTransform.Remove(luaObject[InstanceIDGameObject].gameObject.transform.GetInstanceID());
            Destroy(luaObject[InstanceIDGameObject].gameObject);
            luaObject.Remove(InstanceIDGameObject);
        }
    }

    public void DestroyLuaComponent(int InstanceIDGameObject, int InstanceIDComponent)
    {
        UnityEngine.Component component = GetLuaComponent(InstanceIDGameObject, InstanceIDComponent);
        if (component != null)
        {
            Destroy(component);
            luaObject[InstanceIDGameObject].components.Remove(InstanceIDComponent);
        }
    }

    public void SetLuaComponentEnable(int InstanceIDGameObject, int InstanceIDComponent, bool enable)
    {
        UnityEngine.Component component = GetLuaComponent(InstanceIDGameObject, InstanceIDComponent);
        if (component != null && component.GetType() == typeof(MonoBehaviour))
        {            
            MonoBehaviour monoBehaviour = (MonoBehaviour)component;
            monoBehaviour.enabled = enable;
        }
    }

    public void SetLuaObjectActive(int InstanceIDGameObject, bool active)
    {
        if (luaObject.ContainsKey(InstanceIDGameObject)) 
        {
            luaObject[InstanceIDGameObject].gameObject.SetActive(active);
        }
    }

    public DynValue AddLuaComponent(int InstanceIDGameObject, string nameClassLua)
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
    #endregion

    #region LuaTransform
    public void LuaTransformAddTransform(int InsTransform, Transform transform)
    {
        if (!luaTransform.ContainsKey(InsTransform))
        {            
            luaTransform.Add(InsTransform, transform);
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

    public void SetRotation(int InsTransform, Table quaternion)
    {
        if (luaTransform.ContainsKey(InsTransform))
        {
            Quaternion rot = new Quaternion(Convert.ToSingle(quaternion.Get("x").Number), Convert.ToSingle(quaternion.Get("y").Number), Convert.ToSingle(quaternion.Get("z").Number), Convert.ToSingle(quaternion.Get("w").Number));
            Transform transform = luaTransform[InsTransform];            
            transform.rotation = rot;
        }
    }

    public Table GetRotation(int InsTransform)
    {
        Table table = new Table(luaScript);
        Transform transform = luaTransform[InsTransform];
        table["x"] = transform.rotation.x;
        table["y"] = transform.rotation.y;
        table["z"] = transform.rotation.z;
        table["w"] = transform.rotation.w;
        return table;
    }

    public void SetSmootRote(int InsTransform, Table vector3)
    {
        if (luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            Transform transform = luaTransform[InsTransform];
            luaTransformRot.Add(InsTransform, new LuaTransformRot()
            {
                transform = luaTransform[InsTransform],
                rotMove = pos
            });
        }
    }

    public void StopSmootRote(int InsTransform)
    {
        luaTransformRot.Remove(InsTransform);
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

    public DynValue Require(string path)
    {
        try
        {
            return luaScript.DoString(LoadAsset("lua/" + path.Replace('.', '/')), null, path);

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
