Shader "DBGA/Water"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _NormalMap("Normal Map", 2D) = "white" {}
        _Skybox("Sky box", Cube) = "white" {}
        _WaterSpeed("Water speed", Vector) = (0, 0, 0, 0)
        _WaveSize("Wave size", Range(0, 1)) = 1
        _Fresnel("Fresnel", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Trasparent" "Queue" = "Transparent" }

        Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        fixed4 _Color;
        sampler2D _NormalMap;
        float4 _NormalMap_ST;
        samplerCUBE _Skybox;
        float4 _WaterSpeed;
        float _WaveSize;
        float _Fresnel;

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
            float3 viewDir : TEXCOORD0;
            float2 uv : TEXCOORD1;
        };

        v2f vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.normal = UnityObjectToWorldNormal(v.normal);
            o.tangent = -UnityObjectToWorldDir(v.tangent);
            o.viewDir = -WorldSpaceViewDir(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _NormalMap);
            o.uv.x += _WaterSpeed.x * _SinTime.w;
            o.uv.y += _WaterSpeed.y * _CosTime.w;
            return o;
        }

        fixed4 frag(v2f i) : SV_Target
        {
            float3 normal = normalize(i.normal);
            float3 viewDir = normalize(i.viewDir);

            float3 nmap = UnpackNormal(tex2D(_NormalMap, i.uv));
            nmap = normalize(lerp(float3(0, 0, 1), nmap, _WaveSize));
            float3 tangent = normalize(i.tangent);
            float3 bitangent = cross(normal, tangent);
            float3 modifiedNormal = nmap.x * tangent + nmap.y * bitangent + nmap.z * normal;

            float3 coords = reflect(viewDir, modifiedNormal);
            fixed4 skyboxColor = texCUBE(_Skybox, coords);
            skyboxColor.a = sqrt(1 - pow(dot(modifiedNormal, -viewDir), 2) * _Fresnel);
            return skyboxColor;
        }
        ENDCG
        }
    }
}
