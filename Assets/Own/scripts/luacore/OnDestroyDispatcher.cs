using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnDestroyDispatcher : MonoBehaviour
{
    public System.Action<GameObject> OnObjectDestroyed;
    private void OnDestroy()
    {
        if (OnObjectDestroyed != null) OnObjectDestroyed(gameObject);
    }
}