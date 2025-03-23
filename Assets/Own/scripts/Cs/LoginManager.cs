using DevMini.Plugin.Popup;
using MoonSharp.VsCodeDebugger.SDK;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using Kvp = System.Collections.Generic.KeyValuePair<string, object>;

public class LoginSend
{
    public string email;
    public string password;
}

public class LoginResponse
{
    public LoginData data;
    public string error;
}

public class LoginData
{
    public string username;
    public string token;
}

public class LoginManager : MonoBehaviour
{
    public TMP_InputField ussername;
    public TMP_InputField password;
    public TextMeshProUGUI errorText;
    public GameObject tabLogin;
    public GameObject tabServer;
    public GameObject gridServer;
    public Button prefabButtonServer;
    public Button btnLogin;
    public string URLRegisister => RemoteConfigManager.GetValue(FirebaseKey.URLRegister);

    public bool isLoginSuccess;
    private List<Button> _buttonServers = new List<Button>();
    private string token;
    private bool isCanAutoLogin;
    private IEnumerator Start()
    {
        tabLogin.SetActive(true); 
        tabServer.SetActive(false);
        StartCoroutine(LoadScene());
        yield return AutoLogin();        
        if (isCanAutoLogin)
        {
            Login();
        }
        else
        {
            password.text = "";
        }
    }
#if !UNTY_BUILD_RELEASE
    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.KeypadEnter))
        {
            Login();
        }
    }
#endif

    public void Login()
    {
        if (isCanAutoLogin)
        {
            token = DataCsManager.Instance.token;
            Debug.Log(token);
            ChooseServer(DataCsManager.Instance.server);
            return;
        }
        string username = this.ussername.text;
        string password = this.password.text;
        LoginSend loginSend = new LoginSend() 
        { 
            email = username,
            password = password
        };
        string jsonData = JsonConvert.SerializeObject(loginSend);
        SocketManager.Instance.SendHTTP(SocketManager.Instance.accountUrlLink + "/login.php", jsonData, (json) =>
        {
            LoginResponse response = JsonConvert.DeserializeObject<LoginResponse>(json);
            if (response.error == null)
            {
                token = response.data.token;
                loginSend.password = "***************";
                DataCsManager.Instance.loginData = loginSend;
                DataCsManager.Instance.token = token;
                tabLogin.SetActive(false);
                tabServer.SetActive(true);
                LeanTween.delayedCall(Time.deltaTime, () =>
                {
                    GetServer();
                });
				Debug.Log(token);
            }
            else
            {
                Debug.Log(response.error);
                errorText.gameObject.SetActive(true);
                errorText.text = response.error;
            }
        }, (resp,error) =>
        {
            try
            {
                LoginResponse response = JsonConvert.DeserializeObject<LoginResponse>(resp);
                Debug.Log(response.error);
                errorText.gameObject.SetActive(true);
                errorText.text = response.error;
                LockLogin();
            }
            catch (Exception e)
            {
                Debug.Log(error);
                errorText.gameObject.SetActive(true);
                errorText.text = error;
                LockLogin();
            }
        });        
    }

    public void Regisister()
    {
        PopupManager.Instance.ShowPopup("Popup_YesNoSimple", 
            new Kvp("desrciption", "Bạn có thể đăng ký tại \n" + URLRegisister),
            new Kvp("btnYes", new Kvp[]
            {
                new Kvp("text", "Truy Cập"),
                new Kvp("onClick",(Action)BtnYesClick)
            }),
            new Kvp("btnNo", new Kvp[]
            {
                new Kvp("text", "Đã Hiểu"),
                new Kvp("onClick",(Action)BtnNoClick)
            })
        );
    }

    private void BtnYesClick()
    {
        Application.OpenURL(URLRegisister);
    }

    private void BtnNoClick()
    {
        PopupManager.Instance.HidePopup("Popup_YesNoSimple");
    }

    private void GetServer()
    {
        JObject jobject = new JObject();
        jobject.Add("token", token);
        string jdata = JsonConvert.SerializeObject(jobject);
        SocketManager.Instance.SendHTTP(SocketManager.Instance.accountUrlLink + "/server.php", jdata, (jsonData) =>
        {
            JObject jObject = JObject.Parse(jsonData);
            JArray datas = (JArray)jObject["data"];
            foreach(JObject data in datas)
            {
                CreateButton((string)data["name"], (string)data["url"]);
            }
        });
    }

    private void CreateButton(string name, string url)
    {
        Debug.Log("name: " + name);
        Debug.Log("url: " + url);
        Button buttonServer = Instantiate(prefabButtonServer, gridServer.transform);
        buttonServer.GetComponentInChildren<TextMeshProUGUI>().text = name;
        buttonServer.onClick.AddListener(() => ChooseServer(url));     
        _buttonServers.Add(buttonServer);
    }

    private void ChooseServer(string server)
    {
        SocketManager.Instance.socketUrlLink = server;
        DataCsManager.Instance.server = server;
        DataCsManager.Instance.Save();
        SocketManager.Instance.Connect(token, () =>
        {
            isLoginSuccess = true;
        });
    }

    private IEnumerator LoadScene()
    {
        while (!isLoginSuccess)
        {
            yield return null;
        }
        SceneLoader.Instance.LoadData();
        LuaCore.Instance.Install();
    }    

    public void close()
    {
        Application.Quit();
    }

    public void BackToLogin()
    {
        foreach(Button btn  in _buttonServers) 
        {
            Destroy(btn.gameObject);
        }

        tabLogin.SetActive(true);
        tabServer.SetActive(false);
    }

    private void LockLogin()
    {
        btnLogin.interactable = false;
        StartCoroutine(DelayLock());
    }

    private IEnumerator DelayLock()
    {
        TextMeshProUGUI txt = btnLogin.GetComponentInChildren<TextMeshProUGUI>();
        for(int i = 3; i > 0; i--)
        {
            txt.text = $"Login ({i})";
            yield return new WaitForSeconds(1);
        }
        txt.text = "Login";
        btnLogin.interactable = true;
    }

    public IEnumerator AutoLogin()
    {
        if(DataCsManager.Instance.loginData != null && !string.IsNullOrEmpty(DataCsManager.Instance.server) && !string.IsNullOrEmpty(DataCsManager.Instance.token))
        {
            ussername.text = DataCsManager.Instance.loginData.email;
            password.text = "***************";
            JObject json = new JObject();
            json["token"] = DataCsManager.Instance.token;
            bool complete = false;
            SocketManager.Instance.SendHTTP(DataCsManager.Instance.server + "/api/checkjwt", json.ToString(), (resp) =>
            {
                JObject data = JObject.Parse(resp);
                isCanAutoLogin = (bool)data["status"];
                complete = true;
            }, (resp,err) =>
            {
                isCanAutoLogin = false;
                password.text = "";
                complete = true;
            });
            yield return new WaitUntil(() => complete);
        }
    }
}
