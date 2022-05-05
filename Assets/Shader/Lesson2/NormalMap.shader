Shader "DBGA/Normal Map"
{
    Properties
    {
        _MainTex("Main Map", 2D) = "white" {}
        _NormalTex("Normal Map", 2D) = "white" {}
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
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler2D _NormalTex;
            float4 _NormalTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);                
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = -UnityObjectToWorldDir(v.tangent);
                o.uv = TRANSFORM_TEX(v.uv, _NormalTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 nmap = UnpackNormal(tex2D(_NormalTex, i.uv));
                float3 normal = normalize(i.normal);
                float3 tangent = normalize(i.tangent);
                float3 bitangent = cross(normal, tangent);
                float3 modifiedNormal = nmap.x * tangent + nmap.y * bitangent + nmap.z * normal;
                float3 lightDir = UnityWorldSpaceLightDir(i.vertex.xyz);

                float4 color = tex2D(_MainTex, i.uv);
                return dot(lightDir, modifiedNormal) * color * _LightColor0;
            }
            ENDCG
        }
    }
}
