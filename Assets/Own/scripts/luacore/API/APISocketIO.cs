using MoonSharp.Interpreter;
using SocketIOClient;
using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[MoonSharpUserData]
public class APISocketIO
{
    public static int delay;

    public static void On(string eventName, DynValue func)
    {
#if !UNTY_BUILD_RELEASE
        if (FakeServer.Instance.chanelFake.Find(x => x.Equals(eventName)) != null)
        {
            FakeServer.Instance.On(eventName, (res) =>
            {
                LeanTween.delayedCall(0.1f, () =>
                {
                    Table table = LuaCore.JsonDecode(res);
                    func.Function.CallFunction(table);
                });
            });
        }
        else
#endif
        {
            SocketManager.socket.On(eventName, (res) =>
            {
                //Instance.socketIOOnResponses.Add(new SocketIOOnResponses()
                //{
                //    socketIOResponse = res,
                //    dynvalue = func
                //});
                UnityMainThreadDispatcher.Instance().Enqueue(() =>
                {
                    if (func != null && func.Type == DataType.Function)
                    {
                        Table table = LuaCore.JsonDecode(res.ToString());
                        func.Function.CallFunction(table.Get(1));
                    }
                });
            });
        }

    }

    public static void Off(string eventName)
    {
#if !UNTY_BUILD_RELEASE
        if (FakeServer.Instance.chanelFake.Find(x => x.Equals(eventName)) != null)
        {
            FakeServer.Instance.Off(eventName);
        }
        else
#endif
            SocketManager.socket.Off(eventName);
    }

    public static async void SendMessage(string eventName, DynValue message, DynValue func)
    {
#if !UNTY_BUILD_RELEASE
        if (FakeServer.Instance.chanelFake.Find(x => x.Equals(eventName)) != null)
        {
            string json = null;
            if (message.Type == DataType.Table)
            {
                json = LuaCore.JsonEncode(message.Table);
            }
            FakeServer.Instance.SendToServer(eventName, json, (res) =>
            {
                Table table = LuaCore.JsonDecode(res);
                func.Function.CallFunction(table);
            });
        }
        else
#endif
        {
            string json = null;
            if (message.Type == DataType.Table)
            {
                json = LuaCore.JsonEncode(message.Table);
            }
            SocketManager.socket.Emit(eventName, (res) =>
            {
                //Instance.socketIOResponses.Add(new SocketIOOnResponses()
                //{
                //    socketName = eventName,
                //    socketIOResponse = res,
                //    dynvalue = func
                //});
                UnityMainThreadDispatcher.Instance().Enqueue(() =>
                {
                    if (func != null && func.Type == DataType.Function)
                    {
                        Table table = LuaCore.JsonDecode(res.ToString());
                        func.Function.CallFunction(table.Get(1));
                    }
                });
                    
            }, json);
        }
    }



}
