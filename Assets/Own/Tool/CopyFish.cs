#if UNITY_EDITOR 
using DevMini.Plugin.Popup;
using FSMC.Runtime;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class CopyFish : MonoBehaviour
{
    [Button]
    public void Set()
    {
        LuaScript luaScriptFish = gameObject.GetComponent<LuaScript>();
        LuaFSMC_Executer luaFishExecuter = gameObject.AddComponent<LuaFSMC_Executer>();
        LuaScript luaFishStatus = gameObject.AddComponent<LuaScript>();
        LuaFSMC_Executer luaFishStatusExecuter = gameObject.AddComponent<LuaFSMC_Executer>();
        LuaScript luaMoveToTarget = gameObject.AddComponent<LuaScript>();

        {
            luaScriptFish.filePathLua = "lua/Fish/Fish.lua";            
            luaScriptFish.@params = new List<LuaSerializable>();
            luaScriptFish.@params.Add(new LuaSerializable()
            {
                param = "executer",
                type = LuaType.FSMC_Executer,
                FSMC_Executer = luaFishExecuter,
            });
            luaScriptFish.@params.Add(new LuaSerializable()
            {
                param = "moveToTarget",
                type = LuaType.LuaComponent,
                luaComponent = luaMoveToTarget,
            });
            luaScriptFish.@params.Add(new LuaSerializable()
            {
                param = "bar",
                type = LuaType.LuaComponent,
                luaComponent = findObject<LuaScript>("Assets/Prefabs/Bar.prefab"),
            });
        }

        {
            luaFishExecuter.controller = luaScriptFish;
            luaFishExecuter._controller = findObject<FSMC_Controller>("Assets/StateMachine/FishSwin.asset");
        }

        {
            luaFishStatus.filePathLua = "lua/Fish/FishStatus.lua";
#if !UNTY_BUILD_RELEASE
            luaFishStatus.UpdateCode();
#endif
            luaFishStatus.@params = new List<LuaSerializable>();
            luaFishStatus.@params.Add(new LuaSerializable()
            {
                param = "executer",
                type = LuaType.FSMC_Executer,
                FSMC_Executer = luaFishStatusExecuter,
            });
            luaFishStatus.@params.Add(new LuaSerializable()
            {
                param = "fish",
                type = LuaType.LuaComponent,
                luaComponent = luaScriptFish,
            });

        }

        {
            luaFishStatusExecuter.controller = luaFishStatus;
            luaFishStatusExecuter._controller = findObject<FSMC_Controller>("Assets/StateMachine/FishStatus.asset");
        }

        {
            luaMoveToTarget.filePathLua = "lua/Fish/MoveToTarget.lua";
#if !UNTY_BUILD_RELEASE
            luaMoveToTarget.UpdateCode();
#endif
        }
        EditorUtility.SetDirty(gameObject);
    }

    [Button]
    private void SetFishStatus()
    {
        LuaScript[] luaScripts = gameObject.GetComponents<LuaScript>();
        LuaScript lusaFishStatus = null;
        LuaScript luaFish = null;
        foreach (LuaScript luaScript in luaScripts)
        {
            if (luaScript.filePathLua == "lua/Fish/FishStatus.lua")
            {
                lusaFishStatus = luaScript;
            }
            else if (luaScript.filePathLua == "lua/Fish/Fish.lua")
            {
                luaFish = luaScript;
            }
        }

        lusaFishStatus.@params.Add(new LuaSerializable()
        {
            param = "fish",
            type = LuaType.LuaComponent,
            luaComponent = luaFish,
        });

        EditorUtility.SetDirty(gameObject);
    }

    private T findObject<T>(string path) where T : UnityEngine.Object
    {
        var obj = AssetDatabase.LoadAssetAtPath<T>(path);
        return obj;
    }
}
#endif