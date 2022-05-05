using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bar : MonoBehaviour
{
	[Range(0, 1000)]
	public float maxHealth = 1000;

	[Range(0, 1000)]
	public float currentHealth;

	public Color myFillColor;

	MaterialPropertyBlock block;
	Renderer rend;

	void Awake()
	{
		rend = GetComponent<Renderer>();
		block = new MaterialPropertyBlock();
	}

	void Update()
	{
		block.SetFloat("_Amount", currentHealth / maxHealth);
		block.SetColor("_FillColor", myFillColor);
		rend.SetPropertyBlock(block);
	}
}
