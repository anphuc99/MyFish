using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraHandler : MonoBehaviour
{
    [SerializeField]
    private Camera _camera;

    [SerializeField]
    private float Size;
#if !UNTY_BUILD_RELEASE
    private int screenWidth;
    private int screenHeight;
#endif
    void Start()
    {
#if !UNTY_BUILD_RELEASE
        screenWidth = Screen.width;
        screenHeight = Screen.height;
#endif
        SetCamera();
    }
#if !UNTY_BUILD_RELEASE
    void Update()
    {
        // Kiểm tra xem kích thước màn hình có thay đổi không
        if (screenWidth != Screen.width || screenHeight != Screen.height)
        {
            Debug.Log((float)Screen.width / (float)Screen.height);
            _camera.orthographicSize = Size * (16f/9f / ((float)Screen.width / (float)Screen.height));

            // Cập nhật lại kích thước màn hình để kiểm tra vào lần cập nhật tiếp theo
            screenWidth = Screen.width;
            screenHeight = Screen.height;
        }
    }
#endif
    [Button]
    private void SetCamera()
    {
        _camera.orthographicSize = Size * (16f / 9f / ((float)_camera.pixelWidth / (float)_camera.pixelHeight));
    }
}
