using UnityEngine;
using UnityEngine.EventSystems;

public class DragWindow : MonoBehaviour, IDragHandler
{
    private Canvas canvas;
    public RectTransform rectTransform;

    private void Awake()
    {
        foreach (Transform child in transform.root)
        {
			child.TryGetComponent<Canvas>(out var targetCanvas);
			if (targetCanvas != null)
            {
                canvas = targetCanvas;
                return;
            }
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        int screenX = 1920;
#if UNITY_ANDROID
        int screenY = Screen.height;
#else
        int screenY = 1080;
#endif
        float sizeX = rectTransform.sizeDelta.x * rectTransform.localScale.x;
        float sizeY = rectTransform.sizeDelta.y * rectTransform.localScale.y;
        float x = (screenX - sizeX) / 2;
        float y = (screenY - sizeY) / 2;

        rectTransform.anchoredPosition += eventData.delta / canvas.scaleFactor;
        rectTransform.anchoredPosition = new
        (
            Mathf.Clamp(rectTransform.anchoredPosition.x, -x, x),
            Mathf.Clamp(rectTransform.anchoredPosition.y, -y, y)
        );
    }
}
