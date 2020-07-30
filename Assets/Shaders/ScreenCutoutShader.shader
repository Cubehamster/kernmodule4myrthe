// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ScreenCutoutShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//_Mask("Culling Mask", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Lighting Off
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		ZTest LEqual
				
		Fog{ Mode Global  }

		Pass
		{			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag Lambert alpha:blend
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			sampler2D _MainTex;			
					   
			fixed4 frag (v2f i) : SV_Target
			{
				i.screenPos /= i.screenPos.w;
				fixed4 col = tex2D(_MainTex, float2(i.screenPos.x, i.screenPos.y));
				//l = color.r * 0.3 + color.g * 0.59 + color.b * 0.11
				//clip((col.r > 223 && col.r < 226 && col.g > 58 && col.g < 61 && col.b > 148 && col.b < 151)? -1 : 1);

				return col;
			}		



			ENDCG
		}
	}
}
