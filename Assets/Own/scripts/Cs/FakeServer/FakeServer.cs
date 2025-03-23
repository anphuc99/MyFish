#if UNITY_EDITOR
using Newtonsoft.Json.Linq;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FakeServer : MonoBehaviour
{
    public static FakeServer Instance;
    public List<string> chanelFake;
    public Dictionary<string, Func<string, string>> funcFakeServer = new Dictionary<string, Func<string, string>>(); 
    public Dictionary<string, Action<string>> onServer = new Dictionary<string, Action<string>>();

    private void Awake()
    {
        Instance = this;
        funcFakeServer.Add("chat", FakeChat);
        DontDestroyOnLoad(gameObject);
    }

    public void SendToServer(string chanel, string msg, Action<string> callback)
    {
        var func = funcFakeServer[chanel];
        string data = func(msg);
        callback?.Invoke(data);
    }

    private void SendToClient(string @event, string resp)
    {
        if(onServer.ContainsKey(@event))
        {
            onServer[@event](resp);
        }
    }

    public void On(string @event, Action<string> callback)
    {
        onServer[@event] = callback;
    }

    public void Off(string @event)
    {
        onServer.Remove(@event);
    }

    private List<string> dataChat = new List<string>();
    private string FakeChat(string msg)
    {
        dataChat.Add(msg);
        JObject json = new JObject();
        json["FakeServer"] = true;
        json["code"] = 1;
        json["msg"] = "Thành công";
        return json.ToString();
    }

    [Button]
    private void FakeChatSend(string msg, string UUID, string name)
    {
        JObject send = new JObject();
        send["UUID"] = UUID;
        send["content"] = msg;
        send["channel"] = 1;
        send["name"] = name;
        SendToClient("chat", send.ToString());

        string hapy = "hapy";
        string hi = $"hi {hapy}";
    }
}
#endif