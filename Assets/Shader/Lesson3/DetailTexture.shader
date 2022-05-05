Shader "DBGA/Detail Texture"
{
	Properties
	{
	    _MainTex ("Main Texture", 2D) = "white" { }
		_DetailTex("Detail Texture", 2D) = "white" { }
		_DetailMaxDistance("Detail Max Distance", Float) = 10
	}
	SubShader {
		
	    Pass {	
			CGPROGRAM

			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _DetailTex;
			float4 _DetailTex_ST;

			float _DetailMaxDistance;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
			    float4  pos : SV_POSITION;
				float2  uv0 : TEXCOORD0;
				float2  uv1 : TEXCOORD1;
			};
						
			v2f vert (appdata v)
			{
			    v2f o;
			    o.pos = UnityObjectToClipPos (v.vertex);
				o.uv0 = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv1 = TRANSFORM_TEX(v.uv, _DetailTex);
			    return o;
			}
			
			half4 frag(v2f i) : SV_Target
			{
				half4 color = tex2D(_MainTex, i.uv0);

				float depth = LinearEyeDepth(i.pos.z);
				if (depth > _DetailMaxDistance)
				{
					return color;
				}
				else
				{
					half4 detail = tex2D(_DetailTex, i.uv1);
					return color + (detail - 0.5) * (_DetailMaxDistance - depth) / _DetailMaxDistance;
				}

			}
			ENDCG
	
	    }
	}
	Fallback Off
}