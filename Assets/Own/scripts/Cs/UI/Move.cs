using UnityEngine;

public class Move : MonoBehaviour
{
    private Vector3 startScaleSize = new Vector3(1f, 1f, 1f);
    private Vector3 endScaleSize = new Vector3(0.5f, 0.5f, 0.5f);

	private void OnEnable()
	{
		LeanTween.scale(gameObject, endScaleSize, 0.5f).setLoopPingPong();
	}

	private void OnDisable()
	{
		LeanTween.cancel(gameObject);
		transform.localScale = startScaleSize;
	}
}
