Shader "DBGA/Paint Shader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "white" {}
        _PaintTex("Paint (RGB)", 2D) = "white" {}
        _PaintMaskTex("Paint Mask (Grayscale)", 2D) = "white" {}
        _PaintAmount("Paint Amount", Range(0, 1)) = 1.0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _ScreenSpace ("Screen Space", Range(0,1)) = 0.0
        _ScreenFactor ("Screen Factor", Vector) = (8, 6, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #pragma shader_feature_local WORLD_SPACE SCREEN_SPACE

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _PaintTex;
        sampler2D _PaintMaskTex;
        float _PaintAmount;
        float _ScreenSpace;
        float4 _ScreenFactor;

        struct Input
        {
            float2 uv_MainTex;
            float4 screenPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 baseColor = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 ms_paintColor = tex2D(_PaintTex, IN.uv_MainTex);
            float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
            screenUV *= _ScreenFactor.xy;
            fixed4 ss_paintColor = tex2D(_PaintTex, screenUV);
            fixed4 paintColor = lerp(ms_paintColor, ss_paintColor, _ScreenSpace);
            fixed paintMask = tex2D(_PaintMaskTex, IN.uv_MainTex).r;

            o.Albedo = lerp(baseColor, baseColor + paintColor, paintMask * _PaintAmount).rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
        }
        ENDCG
    }
    FallBack "Standard"
}
