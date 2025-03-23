using System;
using System.Collections.Generic;
using SocketIOClient;
using SocketIOClient.Newtonsoft.Json;
using UnityEngine;
using UnityEngine.UI;
using Newtonsoft.Json.Linq;
using MoonSharp.Interpreter;
using System.Collections;
using UnityEngine.Networking;
using DevMini.Plugin.Popup;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class SocketManager : MonoBehaviour
{
    public static SocketManager Instance;
    public static SocketIOUnity socket;
    public CustomFSMC_Execute execute;
    public string accountUrlLink => RemoteConfigManager.GetValue(FirebaseKey.AccountURL);
    [NonSerialized]
    public string socketUrlLink;
    private Action connected;
    private string token = "";
    private int RepeatConnected = 2;
    private void Awake()
    {        
        Instance = this;
    }

    public void Connect(string token, Action connected = null)
    {
        this.connected = connected;
        this.token = token;
        execute.SetTrigger("OnConnect");
    }

    public void OnConnect()
    {
        LoadingManager.Instance.Show();
        Connected(token, connected);
    }

    public void Connected(string token, Action connected = null)
    {
        //if (_connected == 1) return;
        var uri = new Uri(socketUrlLink);
        this.connected = connected;
        socket = new SocketIOUnity(uri, new SocketIOOptions()
        {
            Auth = new Dictionary<string, string>
            {
                {"token", token }
            },
            Transport = SocketIOClient.Transport.TransportProtocol.WebSocket
        });

        socket.JsonSerializer = new NewtonsoftJsonSerializer();

        socket.OnConnected += OnConnected;

        socket.OnError += OnError;

        socket.OnDisconnected += OnDisconnected;
        socket.ConnectAsync();        
        DontDestroyOnLoad(gameObject);
    }

    public void Disconnected()
    {
        socket.Dispose();
    }

    private void OnError(object sender, string e)
    {
        Debug.LogError(e);
    }

    private void OnConnected(object sender, EventArgs e)
    {
        execute.SetTrigger("ConnectedSuccess");
    }

    public void DelayConnected()
    {
        LeanTween.delayedCall(gameObject,5, () =>
        {
            execute.SetTrigger("ConnectedFail");
        });

    }

    public void ConnectedSuccess()
    {
        LoadingManager.Instance.Hide();
        RepeatConnected = 2;
        Debug.Log("socket.OnConnected");
        connected?.Invoke();
        connected = null;
    }
    
    public void ConnectedFail()
    {
        LoadingManager.Instance.Hide();
        if (RepeatConnected <= 0)
        {
            execute.SetTrigger("OnConnectedFail");
        }
        else
        {
            RepeatConnected--;
            execute.SetTrigger("OnRepeatConected");
        }
    }

    public void Refresh()
    {
        RepeatConnected = 3;
    }

    private void OnDisconnected(object sender, string e)
    {        
        socket.OnConnected -= OnConnected;
        socket.OnDisconnected -= OnDisconnected;
        socket.OnError -= OnError;
        UnityMainThreadDispatcher.Instance().Enqueue(() =>
        {
            DataCsManager.Instance.loginData = null;
            EventManager.onLogout?.Invoke();
            execute.SetTrigger("OnDisconnect");
        });        
    }

    public void BtnYesClick()
    {
        SceneLoader.Instance.LoadScene("Login");
    }

    void OnDestroy()
    {
        socket.Dispose();
    }

    private string uri;
    private string jsonData;
    private Action<string> callBack;
    private Action<string, string> callBackError;
    private string respone;
    private string error;
    public void SendHTTP(string uri, string jsonData, Action<string> callBack, Action<string, string> callBackError = null)
    {
        this.uri = uri;
        this.jsonData = jsonData;
        this.callBack = callBack;
        this.callBackError = callBackError;
        execute.SetTrigger("OnHTTPRequest");
    }

    public void OnSendHTTP()
    {
        LoadingManager.Instance.Show();
        StartCoroutine(SendRequest(uri, jsonData));
    }

    private IEnumerator SendRequest(string url, string jsonData)
    {
        // Tạo UnityWebRequest với phương thức POST
        using (UnityWebRequest webRequest = new UnityWebRequest(url, "POST"))
        {
            // Thiết lập nội dung body của yêu cầu là chuỗi JSON
            byte[] bodyRaw = System.Text.Encoding.UTF8.GetBytes(jsonData);
            webRequest.uploadHandler = new UploadHandlerRaw(bodyRaw);

            // Thiết lập DownloadHandler để xử lý phản hồi từ server
            webRequest.downloadHandler = new DownloadHandlerBuffer();

            // Thiết lập header content type là application/json
            webRequest.SetRequestHeader("authorization", "Devmini " + token);
            webRequest.SetRequestHeader("Content-Type", "application/json");
            webRequest.timeout = 20;
            // Gửi yêu cầu và đợi phản hồi
            yield return webRequest.SendWebRequest();
            if (webRequest.result == UnityWebRequest.Result.ConnectionError || webRequest.result == UnityWebRequest.Result.ProtocolError)
            {
                if (webRequest.error == "Request timeout")
                {
                    Debug.LogError("Error: Request timeout");
                    execute.SetTrigger("OnHTTPRequestFail");
                }
                else
                {
                    Debug.LogError("Error: " + webRequest.error);
                    respone = webRequest.downloadHandler.text;
                    error = webRequest.error;
                    execute.SetTrigger("OnHTTPRequestError");
                }
            }
            else
            {
                // Xử lý phản hồi từ server
                respone = webRequest.downloadHandler.text;
                execute.SetTrigger("OnHTTPRequestSuccess");
            }
            
        }
    }

    public void DelayHTTPRequest()
    {
    }

    public void HTTPSuccess()
    {
        LoadingManager.Instance.Hide();
        callBack?.Invoke(respone);
    }

    public void HTTPError()
    {
        LoadingManager.Instance.Hide();
        callBackError?.Invoke(respone, error);
    }

    public void HTTPFail()
    {
        LoadingManager.Instance.Hide();
        callBackError?.Invoke(respone, error);
    }
}
