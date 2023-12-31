using System;
using System.Collections.Generic;
using SocketIOClient;
using SocketIOClient.Newtonsoft.Json;
using UnityEngine;
using UnityEngine.UI;
using Newtonsoft.Json.Linq;

public class SocketManager : MonoBehaviour
{
    public static SocketManager Instance;

    public static SocketIOUnity socket;
    public string serverUrlLink = "http://localhost:3000";

    private void Awake()
    {
        Instance = this;
        var uri = new Uri(serverUrlLink);
        socket = new SocketIOUnity(uri);


        socket.OnConnected += (sender, e) =>
        {
            Debug.Log("socket.OnConnected");
        };
        socket.Connect();
        DontDestroyOnLoad(gameObject);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            socket.EmitAsync("send", "Hello, server!"); // replace with your message
        }
    }

    void OnDestroy()
    {
        socket.Dispose();
    }
}
