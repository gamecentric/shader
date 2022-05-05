Shader "DBGA/Bar"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _FillColor ("FillColor", Color) = (1, 1, 1, 1)
        _Amount ("Amount", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 coord : TEXCOORD0;
            };

            fixed4 _Color;
            fixed4 _FillColor;
            float _Amount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.coord = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.coord.x < _Amount ? _Color : _FillColor;
            }
            ENDCG
        }
    }
}
