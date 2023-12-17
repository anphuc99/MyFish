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

public class LuaObject
{
    public GameObject gameObject;
    public Dictionary<int, UnityEngine.Component> components = new();
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
    

    private List<string> modulesfile = new List<string>()
    {
        "modules/require",
        "modules/update",
        "modules/Lib",
        "modules/class",
        "modules/GameObject",
        "modules/Component",
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
    }

    
    void Update()
    {
        try
        {
            //luaScript.DoString($"Time.deltaTime = {Time.deltaTime};Time:tick()");
            Timer["deltaTime"] = Time.deltaTime;
            Timer.Get("tick").Function.Call();
        }
        catch (ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
        }
    }

    private void FixedUpdate()
    {
        try
        {
            //luaScript.DoString($"Time.fixedDeltaTime = {Time.fixedDeltaTime};Time:fixedTick()");
            Timer["fixedDeltaTime"] = Time.fixedDeltaTime;
            Timer.Get("fixedTick").Function.Call();
        }
        catch(ScriptRuntimeException ex)
        {
            Debug.LogError("Lua runtime error: " + ex.DecoratedMessage);
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
