using FSMC.Runtime;
using MoonSharp.Interpreter;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
[MoonSharpUserData]
public class APIGameObject
{
    public static void Destroy(int InstanceIDGameObject)
    {
        if (LuaCore.Instance.luaObject.ContainsKey(InstanceIDGameObject))
        {
            LuaCore.Instance.luaTransform.Remove(LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject.transform.GetInstanceID());
            LuaCore.Instance.UnityEvent_Emit(null, LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject.GetInstanceID(), "GameObjectDestroy");
            GameObject.Destroy(LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject);
            LuaCore.GetGlobal("Lib").Table.Get("RemoveGameObject").Function.CallFunction(InstanceIDGameObject);
        }
    }

    public static string GetName(int InstanceIDGameObject)
    {
        return LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject.name;
    }

    public static void DestroyComponent(int InstanceIDGameObject, int InstanceIDComponent)
    {
        UnityEngine.Component component = LuaCore.Instance.LuaObjectGetLuaComponent(InstanceIDGameObject, InstanceIDComponent);
        if (component != null)
        {
            GameObject.Destroy(component);
            LuaCore.Instance.luaObject[InstanceIDGameObject].components.Remove(InstanceIDComponent);
            LuaCore.GetGlobal("Lib").Table.Get("UnRegisterComponent").Function.CallFunction(InstanceIDGameObject, InstanceIDComponent);
        }
    }

    public static void Enable(int InstanceIDGameObject, int InstanceIDComponent, bool enable)
    {
        UnityEngine.Component component = LuaCore.Instance.LuaObjectGetLuaComponent(InstanceIDGameObject, InstanceIDComponent);
        MonoBehaviour monoBehaviour = (MonoBehaviour)component;
        monoBehaviour.enabled = enable;

    }

    public static void SetActive(int InstanceIDGameObject, bool active)
    {
        if (LuaCore.Instance.luaObject.ContainsKey(InstanceIDGameObject))
        {
            LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject.SetActive(active);
        }
    }

    public static bool GetActive(int InstanceIDGameObject)
    {        
        return LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject.activeSelf;
        
    }

    public static DynValue AddComponent(int InstanceIDGameObject, string nameClassLua)
    {
        if (LuaCore.Instance.luaObject.ContainsKey(InstanceIDGameObject))
        {
            LuaScript luaScript = LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject.AddComponent<LuaScript>();
            luaScript.classLua = nameClassLua;
            luaScript.isInitialized = true;
            luaScript.Awake();
            return luaScript.luaObject;
        }

        return null;
    }

    public static DynValue Instantiate(int InstanceIDGameObject)
    {
        GameObject gameObject = GameObject.Instantiate(LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject);
        LuaCore.Instance.LuaObjectAddLuaGameObject(gameObject);
        DynValue gObject = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddGameObject").Function.CallFunction(gameObject.GetInstanceID(), gameObject.tag);
        if (gameObject.transform is RectTransform)
        {
            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(gameObject.transform.GetInstanceID(), gameObject.GetInstanceID(), gameObject.tag);
        }
        else
        {
            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.CallFunction(gameObject.transform.GetInstanceID(), gameObject.GetInstanceID(), gameObject.tag);
        }
        return gObject;
    }

    public static DynValue InstantiateWithParent(int InstanceIDGameObject, int InstanceIDParent)
    {
        Transform parent = LuaCore.Instance.luaTransform[InstanceIDParent];
        GameObject gameObject = GameObject.Instantiate(LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject, parent);
        LuaCore.Instance.LuaObjectAddLuaGameObject(gameObject);
        DynValue gObject = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddGameObject").Function.CallFunction(gameObject.GetInstanceID(), gameObject.tag);
        if (gameObject.transform is RectTransform)
        {
            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(gameObject.transform.GetInstanceID(), gameObject.GetInstanceID(), gameObject.tag);
        }
        else
        {
            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.CallFunction(gameObject.transform.GetInstanceID(), gameObject.GetInstanceID(), gameObject.tag);
        }
        return gObject;
    }

    public static DynValue InstantiateWithPosition(int InstanceIDGameObject, Table vector3, Table quaternion)
    {
        Vector3 v3 = LuaCore.Instance.ConvertTableToVector3(vector3);
        Quaternion qu = LuaCore.Instance.ConvertTableToQuaternion(quaternion);
        GameObject gameObject = GameObject.Instantiate(LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject, v3, qu);
        LuaCore.Instance.LuaObjectAddLuaGameObject(gameObject);
        DynValue gObject = LuaCore.GetGlobal("Lib").Table.Get("GetOrAddGameObject").Function.CallFunction(gameObject.GetInstanceID(), gameObject.tag);
        if (gameObject.transform is RectTransform)
        {
            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddRectTransform").Function.CallFunction(gameObject.transform.GetInstanceID(), gameObject.GetInstanceID(), gameObject.tag);
        }
        else
        {
            LuaCore.GetGlobal("Lib").Table.Get("GetOrAddTransform").Function.CallFunction(gameObject.transform.GetInstanceID(), gameObject.GetInstanceID(), gameObject.tag);
        }
        return gObject;
    }

    public static DynValue GetConponent(int InstanceIDGameObject, string className)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject;
        LuaSerializable luaSerializables = new LuaSerializable();
        luaSerializables.param = "Param";
        
        LuaType luaType = LuaScript.ConvertStringToLuaType(className);
        luaSerializables.type = luaType;
        switch (luaType)
        {
            case LuaType.Image:
                luaSerializables.image = gameObject.GetComponent<Image>();
                break;
            case LuaType.Button:
                luaSerializables.button = gameObject.GetComponent<Button>();
                break;
            case LuaType.Text:
                luaSerializables.text = gameObject.GetComponent<Text>();
                break;
            case LuaType.InputField:
                luaSerializables.inputField = gameObject.GetComponent<InputField>();
                break;
            case LuaType.TextMeshProGUI:
                luaSerializables.textMeshProGUI = gameObject.GetComponent<TextMeshProUGUI>();
                break;
            case LuaType.Slider:
                luaSerializables.slider = gameObject.GetComponent<Slider>();
                break;
            case LuaType.Scrollbar:
                luaSerializables.scrollbar = gameObject.GetComponent<Scrollbar>();
                break;
            case LuaType.SpriteRenderer:
                luaSerializables.spriteRenderer = gameObject.GetComponent<SpriteRenderer>();
                break;
            case LuaType.RectTransform:
                luaSerializables.rectTransform = gameObject.GetComponent<RectTransform>();
                break;
            case LuaType.FSMC_Executer:
                luaSerializables.FSMC_Executer = gameObject.GetComponent<FSMC_Executer>();
                break;
            case LuaType.AudioSource:
                luaSerializables.audioSource = gameObject.GetComponent<AudioSource>();
                break;
            case LuaType.AudioClip:
                luaSerializables.audioClip = gameObject.GetComponent<AudioClip>();
                break;
            case LuaType.SkeletonGraphic:
                luaSerializables.skeletonGraphic = gameObject.GetComponent<SkeletonGraphic>();
                break;
            case LuaType.SkeletonAnimation:
                luaSerializables.skeletonAnimation = gameObject.GetComponent<SkeletonAnimation>();
                break;
            case LuaType.Toggle:
                luaSerializables.toggle = gameObject.GetComponent<Toggle>();
                break;
            case LuaType.TextMeshPro:
                luaSerializables.textMeshPro = gameObject.GetComponent<TextMeshPro>();
                break;

        }

        Table table = LuaScript.ConvertLuaParamToLua(new List<LuaSerializable>() {luaSerializables});
        return table.Get("Param");
    }
}