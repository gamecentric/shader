﻿Shader "DBGA/Gradient Two"
{
    Properties
    {
        _Color0 ("Color #0", Color) = (1, 1, 1, 1)
        _Color1 ("Color #1", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                //float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            fixed4 _Color0;
            fixed4 _Color1;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = v.uv;
                o.color = lerp(_Color0, _Color1, (v.uv.x + v.uv.y) / 2);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}
