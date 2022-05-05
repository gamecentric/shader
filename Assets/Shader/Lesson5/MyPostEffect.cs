using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(MyPostEffectRenderer), PostProcessEvent.AfterStack, "DBGA/My Post Effect")]
public sealed class MyPostEffect : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Effect intensity")]
    public FloatParameter blend = new FloatParameter { value = 0.5f };

    [Range(0f, 10f), Tooltip("Hatch luminosity factor")]
    public FloatParameter hatchFactor = new FloatParameter { value = 0.5f };

    [Range(0f, 10f), Tooltip("Hatch scale X")]
    public FloatParameter hatchScaleX = new FloatParameter { value = 8.0f };

    [Range(0f, 10f), Tooltip("Hatch scale Y")]
    public FloatParameter hatchScaleY = new FloatParameter { value = 6.0f };

    [Tooltip("Hatch weights")]
    public Vector3Parameter weights = new Vector3Parameter { value = new Vector3(0.21f, 0.44f, 0.60f) };

    [Tooltip("Hatch Texture")]
    public TextureParameter hatchTexture = new TextureParameter();
}

public sealed class MyPostEffectRenderer : PostProcessEffectRenderer<MyPostEffect>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("DBGA/My Post Effect"));
        sheet.properties.SetFloat("_Blend", settings.blend);
        sheet.properties.SetVector("_HatchParams", new Vector4(settings.hatchScaleX, settings.hatchScaleY, settings.hatchFactor, 0.0f));
        sheet.properties.SetVector("_HatchTexWeights", settings.weights);
        Texture texture = settings.hatchTexture;
        if (texture != null)
        {
            sheet.properties.SetTexture("_HatchTex", settings.hatchTexture);
        }
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}