using MoonSharp.Interpreter;
using UnityEngine;
using UnityEngine.EventSystems;

public class DragItem : MonoBehaviour, IDragHandler, IBeginDragHandler, IEndDragHandler
{
	private Canvas canvas;
	private CanvasGroup canvasGroup;
	private RectTransform rectTransform;

	private void Awake()
	{
		LuaEvent.Register("OnEnableDrag" + gameObject.GetInstanceID(), OnEnableDrag);
		LuaEvent.Register("OnDisableDrag" + gameObject.GetInstanceID(), OnDisableDrag);
	}

	private void Start()
	{
		canvas = transform.root.GetComponent<Canvas>();
		canvasGroup = GetComponent<CanvasGroup>();
		rectTransform = GetComponent<RectTransform>();
	}

	private void OnDestroy()
	{
		LuaEvent.Unregister("OnEnableDrag" + gameObject.GetInstanceID(), OnEnableDrag);
		LuaEvent.Unregister("OnDisableDrag" + gameObject.GetInstanceID(), OnDisableDrag);
	}

	public void OnEnableDrag(DynValue dynValue)
	{
		enabled = true;
	}

	public void OnDisableDrag(DynValue dynValue)
	{
		enabled = false;
	}

	public void OnBeginDrag(PointerEventData eventData)
	{
		canvasGroup.alpha = 0.6f;
		canvasGroup.blocksRaycasts = false;
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

		float minX = -x;
		float minY = 0;
		float maxX = x - 230;
		float maxY = screenY / 2 * 30 / 100;

		rectTransform.anchoredPosition += eventData.delta / canvas.scaleFactor;
		rectTransform.anchoredPosition = new
		(
			Mathf.Clamp(rectTransform.anchoredPosition.x, minX, maxX),
			Mathf.Clamp(rectTransform.anchoredPosition.y, minY, maxY)
		);
	}

	public void OnEndDrag(PointerEventData eventData)
	{
		canvasGroup.alpha = 1f;
		canvasGroup.blocksRaycasts = true;
	}
}