Shader "DBGA/Hatch Shader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "white" {}
        _HatchTex("Hatch (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _HatchScale ("Hatch Scale", Vector) = (8, 6, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows finalcolor:hatch

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float4 screenPos;
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _HatchTex;
        float4 _HatchScale;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
        }

        void hatch(Input IN, SurfaceOutputStandard o, inout fixed4 color)
        {
            //float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
            float2 screenUV = IN.uv_MainTex;
            screenUV *= _HatchScale.xy;
            fixed4 hatchColor = tex2D(_HatchTex, screenUV);

            float luminosity = dot(float3(0.2126, 0.7152, 0.0722), color.rgb) * _HatchScale.w;
            if (luminosity < 0.25)
                color = hatchColor.x * _Color;
            else if (luminosity < 0.50)
                color = hatchColor.y * _Color;
            else if (luminosity < 0.75)
                color = hatchColor.z * _Color;
            else
                color = _Color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
