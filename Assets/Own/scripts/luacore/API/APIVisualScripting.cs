using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[MoonSharpUserData]
public class APIVisualScripting
{
    public static void Trigger(int InstanceIDGameObject, string eventName, Table table)
    {
        GameObject gameObject = LuaCore.Instance.luaObject[InstanceIDGameObject].gameObject;
        CustomEvent.Trigger(gameObject, eventName, UnpackParam(table));
    }

    private static object[] UnpackParam(Table tables)
    {
        List<object> listObject = new List<object>();
        foreach(var pair in tables.Pairs)
        {
            Table table = pair.Value.Table;
            if(table.Get("value").Type == DataType.Number)
            {
                listObject.Add(table.Get("value").Number);
            }
            else if (table.Get("value").Type == DataType.String)
            {
                listObject.Add(table.Get("value").String);
            }
            else if (table.Get("value").Type == DataType.Boolean)
            {
                listObject.Add(table.Get("value").Boolean);
            }
            else if(table.Get("value").Type == DataType.Table)
            {
                Table table2 = table.Get("value").Table;
                if (table2.Get("type").String == "GameObject")
                {
                    GameObject gameObject = LuaCore.Instance.luaObject[Convert.ToInt32(table2.Get("value").Number)].gameObject;
                    listObject.Add(gameObject);
                }
                else if (table2.Get("type").String == "Transform")
                {
                    Transform transform = LuaCore.Instance.luaTransform[Convert.ToInt32(table2.Get("value").Number)];
                    listObject.Add(transform);
                }
                else if (table2.Get("type").String == "AudioClip")
                {
                    AudioClip audioClip = LuaCore.Instance.luaAudioClip[Convert.ToInt32(table2.Get("value").Number)];
                    listObject.Add(audioClip);
                }
                else if (table2.Get("type").String == "Sprite")
                {
                    Sprite sprite = LuaCore.Instance.luaSprite[Convert.ToInt32(table2.Get("value").Number)];
                    listObject.Add(sprite);
                }
                else if (table2.Get("type").String == "Component")
                {
                    Component component = LuaCore.Instance.luaObject[Convert.ToInt32(table2.Get("value").Table.Get("GameObject").Number)].components[Convert.ToInt32(table2.Get("value").Table.Get("Component").Number)];
                    listObject.Add(component);
                }
                else if (table2.Get("type").String == "Vector3")
                {
                    Vector3 vector3 = LuaCore.Instance.ConvertTableToVector3(table.Get("value").Table);
                    listObject.Add(vector3);
                }
                else if (table2.Get("type").String == "Vector2")
                {
                    Vector2 vector2 = LuaCore.Instance.ConvertTableToVector2(table.Get("value").Table);
                    listObject.Add(vector2);
                }
                else if (table2.Get("type").String == "Quaternion")
                {
                    Quaternion quaternion = LuaCore.Instance.ConvertTableToQuaternion(table.Get("value").Table);
                    listObject.Add(quaternion);
                }
                else if (table2.Get("type").String == "Color")
                {
                    Color color = LuaCore.Instance.ConverTableToColor(table.Get("value").Table);
                    listObject.Add(color);
                }
            }
        }

        return listObject.ToArray();
    }
}
