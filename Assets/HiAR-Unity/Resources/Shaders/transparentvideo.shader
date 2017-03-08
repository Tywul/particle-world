﻿Shader "HiAR/transparentvideo"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FlipX ("FlipX", Float) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Quene"="Transparent"}
		LOD 100
		//Blend One OneMinusSrcColor
		Blend SrcAlpha OneMinusSrcAlpha 
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _FlipX;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, float2(lerp(i.uv.x, (1-i.uv.x), _FlipX), i.uv.y));
				col.a = (1 - (1-col.r)*(1-col.g)*(1-col.b));
				UNITY_APPLY_FOG(i.fogCoord, col);				
				return col;
			}
			ENDCG
		}
	}
}