using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackgroundLoop : MonoBehaviour
{
    public SpriteRenderer spriteRenderer;        
    public float scrollSpeed;
    public float choke;

    private List<SpriteRenderer> _spriteRenderers = new List<SpriteRenderer>();
    private float _sizeSprite;
    private void Start()
    {
        _sizeSprite = spriteRenderer.bounds.size.x - choke;
        _spriteRenderers.Add(spriteRenderer);
        for(int i = 0; i < 2; i++)
        {
            _spriteRenderers.Add(Instantiate(spriteRenderer));
        }
        SetPosition();
    }

    private void FixedUpdate()
    {
        for(int i = 0; i < _spriteRenderers.Count; i++)
        {
            var spriteRenderer = _spriteRenderers[i];
            spriteRenderer.transform.position += Vector3.left * scrollSpeed * Time.fixedDeltaTime;
            CheckPos(spriteRenderer.transform);
        }
    }

    private void SetPosition()
    {
        for(int i = 0; i < _spriteRenderers.Count; i++)
        {
            var spriteRenderer = _spriteRenderers[i];
            spriteRenderer.transform.position = new Vector2(_sizeSprite * i, 0);
        }
    }

    private void CheckPos(Transform transform)
    {
        if(transform.position.x <= -_sizeSprite)
        {
            transform.position = new Vector2(_sizeSprite*2, 0);
        }
    }
}