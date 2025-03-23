using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoloadSigleTonManager : MonoBehaviour
{
    public static AutoloadSigleTonManager Instance;
    public List<GameObject> sigleTon;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
            return;
        }
        foreach (var t in sigleTon)
        {
            GameObject load = Instantiate(t);
            DontDestroyOnLoad(load);
        }
    }
}
