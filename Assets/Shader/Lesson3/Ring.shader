Shader "DBGA/Ring"
{
	Properties
	{
	    _InternalRadius ("Internal Radius", Range(0,1)) = 0.6
	    _ExternalRadius ("External Radius", Range(0,1)) = 1.0
	    _MainTex ("Texture", 2D) = "white" { }
	    _Repetitions ("Repetitions", Float) = 4.0
		_AngleFactor ("Angle factor", Float) = 6.0
		_Fill ("Fill", Range(0, 6.283185)) = 6.283185
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		
	    Pass {
	    	Blend SrcAlpha OneMinusSrcAlpha     // Alpha blending
			ZWrite Off Cull Off
			ZTest Always
			
			CGPROGRAM

			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float _InternalRadius;
			float _ExternalRadius;
			float _Repetitions;
			sampler2D _MainTex;
			float _Fill;
			float _AngleFactor;

			struct v2f {
			    float4  pos : SV_POSITION;
			    float2  uv : TEXCOORD0;
			};
						
			v2f vert (appdata_base v)
			{
			    v2f o;
			    o.pos = UnityObjectToClipPos (v.vertex);
			    o.uv = v.texcoord * 2.0 - 1.0;
			    return o;
			}
			
			half4 frag(v2f i) : SV_Target
			{
				float len = length(i.uv);
				float v = (len - _InternalRadius) / (_ExternalRadius - _InternalRadius);
				if (v < 0 || v > 1)
				{
					discard;
				}

				float u = atan2(i.uv.y, i.uv.x) + 3.14159265;
				if (u > _Fill)
				{
					discard;
				}
				return tex2D(_MainTex, float2(u * (_AngleFactor / 3.14159265), v));
			}
			ENDCG
	
	    }
	}
	Fallback Off
}