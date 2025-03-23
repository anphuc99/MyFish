using System.Collections.Generic;
using UnityEngine;

public class DecorationsHolder : MonoBehaviour
{
	private List<Square> points = new List<Square>();
	public Transform dragZone;
	public Transform content;
	public GameObject prefab;
	public Transform annotations;

	public static DecorationsHolder Instance { get; private set; }

	private void Awake()
	{
		if (Instance != null)
		{
			Destroy(gameObject);
		}
		Instance = this;
	}

	private void Start()
	{
        foreach (Transform child in annotations)
        {
			points.Add(new Square(child.gameObject));
        }
	}

	public List<Square> GetPoints()
	{
		return points;
	}

	public void AddHolder(Square square)
    {
		points.Add(square);
    }

	public void RemoveHolder(Square square)
	{
		points.Remove(square);
	}
}

public struct Square
{
    public GameObject GameObject { get; set; }
    public Vector2 Origin { get; set; }
	public Vector2 Min { get; set; }
	public Vector2 Max { get; set; }

	public Square(GameObject gameObject)
	{
		GameObject = gameObject;
		Origin = gameObject.transform.position;
		Min = Origin - new Vector2(0.7f, 0.7f);
		Max = Origin + new Vector2(0.7f, 0.7f);
	}
}
