Shader "DBGA/Ring Lit"
{
	Properties
	{
	    _InternalRadius ("Internal Radius", Range(0,1)) = 0.6
	    _ExternalRadius ("External Radius", Range(0,1)) = 1.0
	    _AngleOffset ("Angle Offset", Range(0, 1)) = 0.0
	    _MainTex ("Texture", 2D) = "white" { }
	    _Repetitions ("Repetitions", Float) = 4.0
	    _LightDir ("Light Direction", Vector) = (1, -1, 1, 1)
		_LightColor ("Light Color", Color) = (1, 1, 1, 1)
		_AmbientColor ("Ambient Color", Color) = (0.2, 0.2, 0.2, 1)
		_Flat ("Flat", Float) = 0.0

		_StartAngle ("StartAngle", Float) = 0.0
		_Fill ("Fill", Float) = 1.0
		_Opacity ("Opacity", Float) = 1.0

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
			float _AngleOffset;
			float _Repetitions;
			bool _Flat;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float3 _LightDir;
			half4 _LightColor;
			half4 _AmbientColor;
			
			float _StartAngle;
			float _Fill;
			float _Opacity;

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
			
			half4 frag (v2f i) : SV_Target
			{
				float r = (_ExternalRadius - _InternalRadius) * 0.5;
				float d = (length(i.uv) - _InternalRadius - r) / r;
				float opacity = _Opacity;
				
				if (d < -1.0 || d > 1.0)
				{
					discard;
				}

				float t = _Flat ? d * 0.5 + 0.5 : acos(d) * -0.31830988618379;
				float angle = atan2(i.uv.y, i.uv.x);
				
				float refAngle = fmod(angle - _StartAngle, radians(360.0));
				
				if (refAngle < 0.0 || refAngle > _Fill)
				{
					discard;
				}
				
				float c = length(i.uv);
				float3 norm = float3(d * i.uv.x / c, d * i.uv.y / c, sqrt(1.0 - d * d));
				float angleColor = (angle * _Repetitions) * -0.15915494309190 + _AngleOffset;

				half4 sampledColor = tex2D(_MainTex, float2(angleColor, t));
				half4 finalColor = sampledColor * (dot(norm, _LightDir) * _LightColor + _AmbientColor);
	    		
				finalColor.a = sampledColor.a * opacity;
	    		
	    		return finalColor;
			}
			ENDCG
	
	    }
	}
	Fallback Off
} 