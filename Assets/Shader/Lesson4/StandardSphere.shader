﻿Shader "DBGA/Standard Sphere"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Skybox("Skybox", Cube) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 sphereCoords;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        samplerCUBE _Skybox;

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.sphereCoords = reflect(-WorldSpaceViewDir(v.vertex), UnityObjectToWorldNormal(v.normal));
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = _Color * texCUBE(_Skybox, IN.sphereCoords);
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
