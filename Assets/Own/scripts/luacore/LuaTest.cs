using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;

public class LuaTest : MonoBehaviour
{
    public LuaScript testScript;
    public LuaScript testComponent;

    private void Awake()
    {
        StartCoroutine(StartTest());
    }

    private void LogTest(string nameTest, bool rs)
    {
        if(rs)
        {
            Print("Test result:", nameTest, "Pass");
        }
        else
        {
            Error("Test result:", nameTest, "fail");
        }
    }

    private void Print(params object[] strs)
    {
        string[] log = new string[strs.Length];
        for (int i = 0; i < log.Length; i++)
        {
            log[i] = Convert.ToString(strs[i]);
        }

        Debug.Log(string.Join('\t', log));
    }

    private void Error(params object[] strs)
    {
        string[] log = new string[strs.Length];
        for (int i = 0; i < log.Length; i++)
        {
            log[i] = Convert.ToString(strs[i]);
        }

        Debug.LogError(string.Join('\t', log));
    }

    private IEnumerator StartTest()
    {
        yield return TestAttrNumber();
        yield return TestAttrString();
        yield return TestComponentGetInstanceID();
        yield return TestComponentSetEnable();
        yield return TestComponentSetDisable();
        yield return TestComponentDestroy();
        yield return TestGameObjectDestroy();        
        yield return TestComponentInstantiateGameObject();        
        yield return TestComponentInstantiate();        
        yield return TestComponentGetComponent();
        //yield return TestCoroutineWaitForSecond();
        //yield return TestCoroutineWaitForFrame();
        //yield return TestCoroutineWaitUntil();
        //yield return TestCoroutineWaitCo();
    }

    private IEnumerator TestAttrNumber()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestAttrNumber";
        DynValue _luaObject = test.luaObject;
        DynValue num = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(_luaObject, "number");
        if(num.Type == DataType.Number)
        {
            if(test.@params.Find(x=>x.param == "number").number == num.Number)
            {
                LogTest("TestAttrNumber", true);
                yield return null;
                yield break;
            }
        }

        LogTest("TestAttrNumber", false);
        yield return null;
    }

    private IEnumerator TestAttrString()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestAttrString";
        DynValue _luaObject = test.luaObject;
        DynValue num = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(_luaObject, "str");
        if (num.Type == DataType.String)
        {
            if (test.@params.Find(x => x.param == "str").@string == num.String)
            {
                LogTest("TestAttrString", true);
                yield return null;
                yield break;
            }
        }

        LogTest("TestAttrString", false);
        yield return null;
    }

    private IEnumerator TestComponentGetInstanceID()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestComponentGetInstanceID";
        DynValue _luaObject = test.luaObject;
        DynValue id = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "GetInstanceID");
        if(id.Type == DataType.Number)
        {
            if(test.GetInstanceID() == id.Number)
            {
                LogTest("TestComponentGetInstanceID", true);
                yield return null;
                yield break;
            }
        }

        LogTest("TestComponentGetInstanceID", false);
        yield return null;
    }

    private IEnumerator TestComponentSetEnable()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestComponentSetEnable";
        test.enabled = false;
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "SetEnable", true);
        if (test.enabled == true)
        {            
            LogTest("TestComponentSetEnable", true);
            yield return null;
            yield break;            
        }

        LogTest("TestComponentSetEnable", false);
        yield return null;
    }

    private IEnumerator TestComponentSetDisable()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestComponentSetDisable";
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "SetEnable", false);
        if (test.enabled == false)
        {
            LogTest("TestComponentSetDisable", true);
            yield return null;
            yield break;
        }

        LogTest("TestComponentSetDisable", false);
        yield return null;
    }
    
    private IEnumerator TestComponentDestroy()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestComponentDestroy";
        LuaScript test2 = Instantiate(testScript);
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "Destroy", test2.luaObject);
        yield return null;
        if (test2.IsDestroyed())
        {
            LogTest("TestComponentDestroy", true);
            yield return null;
            yield break;
        }

        LogTest("TestComponentDestroy", false);
        yield return null;
    }

    private IEnumerator TestGameObjectDestroy()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestGameObjectDestroy";
        LuaScript test2 = Instantiate(testScript);
        DynValue _luaObject = test.luaObject;
        GameObject gameObject = test2.gameObject;
        DynValue obj = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(test2.luaObject, "gameObject");
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "Destroy", obj);
        yield return null;
        if (gameObject.IsDestroyed())
        {
            LogTest("TestGameObjectDestroy", true);
            yield return null;
            yield break;
        }

        LogTest("TestGameObjectDestroy", false);
        yield return null;
    }

    private IEnumerator TestComponentInstantiateGameObject()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestComponentInstantiateGameObject";
        LuaScript test2 = Instantiate(testScript);
        DynValue obj = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(test2.luaObject, "gameObject");
        DynValue _luaObject = test.luaObject;
        DynValue rs = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "Instantiate", obj);
        DynValue idobject = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(rs, "GetInstanceID");
        if (idobject.Type == DataType.Number)
        {            
            // Tìm tất cả các đối tượng trong scene
            GameObject[] allObjects = GameObject.FindObjectsOfType<GameObject>();

            // Lặp qua tất cả các đối tượng để tìm đối tượng có InstanceID tương ứng
            foreach (GameObject obj2 in allObjects)
            {
                if (obj2.GetInstanceID() == idobject.Number)
                {

                    LogTest("TestComponentInstantiateGameObject", true);
                    yield return null;  
                    yield break;                    
                }
            }
        }

        LogTest("TestComponentInstantiateGameObject", false);
        yield return null;
    }

    private IEnumerator TestComponentInstantiate()
    {
        LuaScript test = Instantiate(testScript);
        test.name = "TestComponentInstantiate";
        LuaScript test2 = Instantiate(testScript);
        DynValue _luaObject = test.luaObject;
        DynValue rs = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "Instantiate", test2.luaObject);        
        DynValue obj = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(rs, "gameObject");
        DynValue idobject = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(obj, "GetInstanceID");
        DynValue idcpm = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(rs, "GetInstanceID");
        if (idobject.Type == DataType.Number)
        {
            // Tìm tất cả các đối tượng trong scene
            GameObject[] allObjects = GameObject.FindObjectsOfType<GameObject>();

            // Lặp qua tất cả các đối tượng để tìm đối tượng có InstanceID tương ứng
            foreach (GameObject obj2 in allObjects)
            {
                if (obj2.GetInstanceID() == idobject.Number)
                {
                    LuaScript luaScript = obj2.GetComponent<LuaScript>();
                    if(luaScript.GetInstanceID() == idcpm.Number)
                    {
                        LogTest("TestComponentInstantiate", true);
                        yield return null;
                        yield break;
                    }
                    else
                    {
                        break;
                    }
                }
            }
        }

        LogTest("TestComponentInstantiate", false);
        yield return null;
    }

    private IEnumerator TestComponentGetComponent()
    {
        LuaScript test = Instantiate(testComponent);
        test.name = "TestComponentGetComponent";
        DynValue _luaObject = test.luaObject;
        DynValue hiCpm = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "GetComponent", "Test2");
        DynValue idHi = LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(hiCpm, "GetInstanceID");
        if(idHi.Type == DataType.Number)
        {            
            LuaScript luaScript = test.GetComponents<LuaScript>().ToList().Find(x => x.classLua == "Test2");
            if(luaScript.GetInstanceID() == idHi.Number)
            {
                var p = luaScript.@params.Find(x => x.param == "str");
                DynValue str = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(hiCpm, "str");
                if(p.@string == str.String)
                {
                    LogTest("TestComponentGetComponent", true);
                    yield return null;
                    yield break;
                }
            }
        }
        LogTest("TestComponentGetComponent", false);
        yield return null;
    }

    private IEnumerator TestCoroutineWaitForSecond()
    {
        LuaScript test = Instantiate(testComponent);
        test.name = "TestCoroutineWaitForSecond";
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "TestCoroutineWaitForSecond");
        yield return new WaitForSeconds(3);
        DynValue rs = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(_luaObject, "testCoroutine");
        if (rs.Type == DataType.Boolean && rs.Boolean)
        {
            LogTest("TestComponentGetComponent", true);
            yield return null;
            yield break;
        }

        LogTest("TestComponentGetComponent", false);
        yield return null;
    }
    
    private IEnumerator TestCoroutineWaitForFrame()
    {
        LuaScript test = Instantiate(testComponent);
        test.name = "TestCoroutineWaitForFrame";
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "TestCoroutineWaitForFrame");
        yield return new WaitForSeconds(3);
        DynValue rs = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(_luaObject, "testCoroutine");
        if (rs.Type == DataType.Boolean && rs.Boolean)
        {
            LogTest("TestCoroutineWaitForFrame", true);
            yield return null;
            yield break;
        }

        LogTest("TestCoroutineWaitForFrame", false);
        yield return null;
    }
    
    private IEnumerator TestCoroutineWaitUntil()
    {
        LuaScript test = Instantiate(testComponent);
        test.name = "TestCoroutineWaitUntil";
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "TestCoroutineWaitUntil");
        yield return new WaitForSeconds(3);
        DynValue rs = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(_luaObject, "testCoroutine");
        if (rs.Type == DataType.Boolean && rs.Boolean)
        {
            LogTest("TestCoroutineWaitUntil", true);
            yield return null;
            yield break;
        }

        LogTest("TestCoroutineWaitUntil", false);
        yield return null;
    }  
    
    private IEnumerator TestCoroutineWaitCo()
    {
        LuaScript test = Instantiate(testComponent);
        test.name = "TestCoroutineWaitCo";
        DynValue _luaObject = test.luaObject;
        LuaCore.GetGlobal("Lib").Table.Get("ExecuteFunction").Function.Call(_luaObject, "TestCoroutineWaitCo");
        yield return new WaitForSeconds(3);
        DynValue rs = LuaCore.GetGlobal("Lib").Table.Get("GetAttrObject").Function.Call(_luaObject, "testCoroutine");
        if (rs.Type == DataType.Boolean && rs.Boolean)
        {
            LogTest("TestCoroutineWaitCo", true);
            yield return null;
            yield break;
        }

        LogTest("TestCoroutineWaitCo", false);
        yield return null;
    }

    
}
