using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AssetBundleVersion : MonoBehaviour
{
    public static AssetBundleVersion Instance;
    public int version;

    private void Awake()
    {
        Instance = this;
    }
}
