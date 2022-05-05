Shader "DBGA/Flag"
{
    Properties
    {
        _Color0("Color #0", Color) = (1, 1, 1, 1)
        _Color1("Color #1", Color) = (1, 1, 1, 1)
        _ScaleFactor ("ScaleFactor", Vector) = (1, 1, 0, 0)
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
                float2 uv : TEXCOORD0;
            };

            fixed4 _Color0;
            fixed4 _Color1;
            float4 _ScaleFactor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _ScaleFactor.xy;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = frac(i.uv) - 0.5;
                return uv.x * uv.y > 0 ? _Color0 : _Color1;
            }
            ENDCG
        }
    }
}
