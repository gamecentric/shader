Shader "DBGA/Colored Ring"
{
    Properties
    {
        _RingTex("Ring Texture", 2D) = "white" {}
        _FilledRingTex("Filled Ring Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _Color2("Color2", Color) = (1, 0, 1, 1)
        _InternalRadius("Internal Radius", Range(0,1)) = 0.6
        _ExternalRadius("External Radius", Range(0,1)) = 1.0
        _Amount("Amount", Range(0, 360)) = 360
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _RingTex;
            sampler2D _FilledRingTex;
            fixed4 _Color;
            fixed4 _Color2;
            float _InternalRadius;
            float _ExternalRadius;
            float _Amount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.vertex * 2;
                //o.uv = (v.uv + 1) * 0.5;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float l = length(i.uv);
                if (l < _InternalRadius || l > _ExternalRadius)
                    discard;
                float angle = degrees(atan2(i.uv.y, i.uv.x)) + 180.0;
                float y = (l - _InternalRadius) / (_ExternalRadius - _InternalRadius);
                return angle < _Amount ? tex2D(_RingTex, float2(angle / 120.0, y)) : tex2D(_FilledRingTex, float2(angle / 120.0, y));
            }
            ENDCG
        }
    }
}
