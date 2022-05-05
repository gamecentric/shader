using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBar : MonoBehaviour
{
    [Range(0, 100)]
    public float health = 1;

    public float maxHealth = 100;

    public Color fillColor;

    Renderer rend;
    MaterialPropertyBlock propBlock;

    void Start()
    {
        rend = GetComponent<Renderer>();
        propBlock = new MaterialPropertyBlock();
    }

    // Update is called once per frame
    void Update()
    {
        propBlock.SetColor("_FillColor", fillColor);
        propBlock.SetFloat("_Amount", (health / maxHealth) * 360.0f);
        rend.SetPropertyBlock(propBlock);
    }
}
