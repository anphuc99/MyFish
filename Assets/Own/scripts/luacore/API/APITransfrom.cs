using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuaTransformMove
{
    public Transform transform;
    public Vector3 posMove;
}

public struct LuaTransformRot
{
    public Transform transform;
    public Vector3 rotMove;
}

public class UpdateLuaTransfrom : IUpdate
{
    public static UpdateLuaTransfrom Instance;
    public Dictionary<int, LuaTransformMove> luaTransformMove = new();
    public Dictionary<int, LuaTransformRot> luaTransformRot = new();

    public UpdateLuaTransfrom() 
    {
        Instance = this;
    }

    public void OnUpdate()
    {
        List<int> listremove = new List<int>();
        foreach (var transform in luaTransformMove)
        {
            if (transform.Value.transform != null)
            {
                transform.Value.transform.position += transform.Value.posMove * Time.deltaTime;
            }
            else
            {
                listremove.Add(transform.Key);
            }
        }

        foreach(int remove in listremove)
        {
            luaTransformMove.Remove(remove);
        }

        foreach (var transform in luaTransformRot.Values)
        {
            transform.transform.Rotate(transform.rotMove * Time.deltaTime);
        }
    }
}

[MoonSharpUserData]
public class APITransfrom
{
    public static Table GetPosition(int InsTransform)
    {
        Table table = LuaCore.CreateTable();
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        table["x"] = transform.position.x;
        table["y"] = transform.position.y;
        table["z"] = transform.position.z;
        return table;
    }

    public static void SetPosition(int InsTransform, Table vector3)
    {
        if (LuaCore.Instance.luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            Transform transform = LuaCore.Instance.luaTransform[InsTransform];
            transform.position = pos;
        }
    }

    public static Table GetLocalPosition(int InsTransform)
    {
        Table table = LuaCore.CreateTable();
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        table["x"] = transform.localPosition.x;
        table["y"] = transform.localPosition.y;
        table["z"] = transform.localPosition.z;
        return table;
    }

    public static void SetLocalPosition(int InsTransform, Table vector3)
    {
        if (LuaCore.Instance.luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = LuaCore.Instance.ConvertTableToVector3(vector3);
            Transform transform = LuaCore.Instance.luaTransform[InsTransform];
            transform.localPosition = pos;
        }
    }

    public static Table GetLocalScale(int InsTransform)
    {
        Table table = LuaCore.CreateTable();
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        table["x"] = transform.localScale.x;
        table["y"] = transform.localScale.y;
        table["z"] = transform.localScale.z;
        
        return table;
    } 
    
    public static Table GetLossyScale(int InsTransform){
        Table table = LuaCore.CreateTable();
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        table["x"] = transform.lossyScale.x;
        table["y"] = transform.lossyScale.y;
        table["z"] = transform.lossyScale.z;
        return table;
    }

    public static void SetLocalScale(int InsTransform, Table vector3)
    {
        if (LuaCore.Instance.luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            Transform transform = LuaCore.Instance.luaTransform[InsTransform];
            transform.localScale = pos;
        }
    }


    public static void Move(int InsTransform, Table vector3)
    {
        if (LuaCore.Instance.luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            if (UpdateLuaTransfrom.Instance.luaTransformMove.ContainsKey(InsTransform))
            {
                UpdateLuaTransfrom.Instance.luaTransformMove[InsTransform].posMove = pos;
            }
            else
            {
                UpdateLuaTransfrom.Instance.luaTransformMove.Add(InsTransform, new LuaTransformMove()
                {
                    transform = LuaCore.Instance.luaTransform[InsTransform],
                    posMove = pos
                });
            }
        }
    }

    public static void StopMove(int InsTransform)
    {
        UpdateLuaTransfrom.Instance.luaTransformMove.Remove(InsTransform);
    }

    public static void SetRotation(int InsTransform, Table quaternion)
    {
        if (LuaCore.Instance.luaTransform.ContainsKey(InsTransform))
        {
            Quaternion rot = new Quaternion(Convert.ToSingle(quaternion.Get("x").Number), Convert.ToSingle(quaternion.Get("y").Number), Convert.ToSingle(quaternion.Get("z").Number), Convert.ToSingle(quaternion.Get("w").Number));
            Transform transform = LuaCore.Instance.luaTransform[InsTransform];
            transform.rotation = rot;
        }
    }

    public static Table GetRotation(int InsTransform)
    {
        Table table = LuaCore.CreateTable();
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        table["x"] = transform.rotation.x;
        table["y"] = transform.rotation.y;
        table["z"] = transform.rotation.z;
        table["w"] = transform.rotation.w;
        return table;
    }

    public static void SetSmootRote(int InsTransform, Table vector3)
    {
        if (LuaCore.Instance.luaTransform.ContainsKey(InsTransform))
        {
            Vector3 pos = new Vector3(Convert.ToSingle(vector3.Get("x").Number), Convert.ToSingle(vector3.Get("y").Number), Convert.ToSingle(vector3.Get("z").Number));
            UpdateLuaTransfrom.Instance.luaTransformRot.Add(InsTransform, new LuaTransformRot()
            {
                transform = LuaCore.Instance.luaTransform[InsTransform],
                rotMove = pos
            });
        }
    }

    public static void StopSmootRote(int InsTransform)
    {
        UpdateLuaTransfrom.Instance.luaTransformRot.Remove(InsTransform);
    }

    public static int GetChildCount(int InsTransform)
    {
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        return transform.childCount;
    }

    public static Table GetChild(int InsTransform, int index)
    {
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        Table table = LuaCore.CreateTable();
        table["transform"] = transform.GetChild(index).GetInstanceID();
        table["gameObject"] = transform.GetChild(index).gameObject.GetInstanceID();
        LuaCore.Instance.LuaTransformAddTransform(transform.GetChild(index).GetInstanceID(), transform.GetChild(index));
        return table;
    }

    public static Table GetAllChild(int InsTransform)
    {
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        Table table =   LuaCore.CreateTable();
        for (int i = 0; i < transform.childCount; i++)
        {
            Table table1 = LuaCore.CreateTable();
            table1["transform"] = transform.GetChild(i).GetInstanceID();
            table1["gameObject"] = transform.GetChild(i).gameObject.GetInstanceID();
            table[i + 1] = table1;
            LuaCore.Instance.LuaTransformAddTransform(transform.GetChild(i).GetInstanceID(), transform.GetChild(i));
        }
        return table;
    }

    public static Table GetParent(int InsTransform)
    {
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        Table table1 = LuaCore.CreateTable();
        if(transform.parent != null)
        {
            table1["transform"] = transform.parent.GetInstanceID();
            table1["gameObject"] = transform.parent.gameObject.GetInstanceID();
            LuaCore.Instance.LuaTransformAddTransform(transform.parent.GetInstanceID(), transform.parent);
            return table1;
        }
        else
        {
            return null;
        }
    }

    public static void LockAt(int InsTransform, Table worldPosition)
    {
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        Vector3 vector3 = LuaCore.Instance.ConvertTableToVector3(worldPosition);
        transform.LookAt(vector3);
    }

    public static void SetParent(int InsTransform, int InsTransformParent, bool worldPositionStays)
    {
        Transform transform = LuaCore.Instance.luaTransform[InsTransform];
        Transform transformParent = LuaCore.Instance.luaTransform[InsTransformParent];
        transform.SetParent(transformParent, worldPositionStays);
    }   
}
