using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public bool isTest;
    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
        if (isTest)
            SceneManager.LoadScene("Test");
        else
            SceneManager.LoadScene("Login");
    }
}
