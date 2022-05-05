Shader "DBGA/My Post Effect"
{
    Properties
    {
        _Blend ("Blend factor", Range(0, 1)) = 0
        _HatchParams("Hatch parameters", Vector) = (6, 8, 0, 0)
        _HatchTexWeights ("Hatch parameters", Vector) = (0.21, 0.44, 0.60, 0)
        _HatchTex ("Hatch texture", 2D) = "white"  {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off ZWrite Off ZTest Always

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

            sampler2D _MainTex;
            sampler2D _HatchTex;
            float _Blend;
            float4 _HatchParams;
            float4 _HatchTexWeights;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(v.vertex.xy, 0.0, 1.0);
                o.uv.x = (1.0 + v.vertex.x) * 0.5;
                o.uv.y = (1.0 - v.vertex.y) * 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                fixed4 hatch = tex2D(_HatchTex, i.uv * _HatchParams.xy);
                float luminosity = min(dot(float3(0.2126, 0.7152, 0.0722), color.rgb) * _HatchParams.z, 1.0);
                fixed hatchColor = 1;
                if (luminosity < _HatchTexWeights.x)
                    hatchColor = lerp(0, hatch.x, luminosity / _HatchTexWeights.x);
                else if (luminosity < _HatchTexWeights.y)
                    hatchColor = lerp(hatch.x, hatch.y, (luminosity - _HatchTexWeights.x) / (_HatchTexWeights.y - _HatchTexWeights.x));
                else if (luminosity < _HatchTexWeights.z)
                    hatchColor = lerp(hatch.y, hatch.z, (luminosity - _HatchTexWeights.y) / (_HatchTexWeights.z - _HatchTexWeights.y));
                else
                    hatchColor = lerp(hatch.z, 1, (luminosity - _HatchTexWeights.z) / (1.0 - _HatchTexWeights.z));
                color.rgb = lerp(color.rgb, color.rgb * hatchColor / luminosity, _Blend);
                return color;
            }
            ENDCG
        }
    }
}
