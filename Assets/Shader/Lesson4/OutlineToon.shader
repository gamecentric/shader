Shader "DBGA/Outline Lit"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _RampTex("Ramp Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth ("Outline Width", Range(0,0.01)) = 0.0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        UsePass "DBGA/Outline/OUTLINE"
        UsePass "DBGA/Shading/Toon/TOON"
    }
}
