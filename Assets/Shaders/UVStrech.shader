Shader "Custom/UV_Stretch"
{
	Properties{
		_MainTex("Texture", 2D) = "white"{}
		_Color("Colour", Color) = (1.0, 1.0, 1.0, 1.0)
		_bottomleftXInput("BLXinput", Float) = 0
		_bottomleftYInput("BLYinput", Float) = 0
		_bottomrightXInput("BRXinput", Float) = 0
		_bottomrightYInput("BRYinput", Float) = 0
		_toprightXInput("TRXinput", Float) = 0
		_toprightYInput("TRYinput", Float) = 0
		_topleftXInput("TLXinput", Float) = 0
		_topleftYInput("TLYinput", Float) = 0
	}

		SubShader
		{
			Pass
			{
				CGPROGRAM

				#pragma vertex vertexFunc
				#pragma fragment fragmentFunc

				#include "UnityCG.cginc"

				struct appdata {
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					uint vid : SV_VertexID; // vertex ID, needs to be uint
				};

				struct v2f {
					float4 position : SV_POSITION;
					float2 uv : TEXCOORD0;
				};

				//fixed4 _VertexOffset;

				fixed4 _Color;
				sampler2D _MainTex;
				float _AnimationSpeed;
				float _OffsetSize;
				float _bottomleftYInput;
				float _bottomleftXInput;
				float _bottomrightYInput;
				float _bottomrightXInput;
				float _toprightYInput;
				float _toprightXInput;
				float _topleftYInput;
				float _topleftXInput;

				v2f vertexFunc(appdata IN) {
					v2f OUT;
					if (IN.vid == 0) {
						IN.uv.x += _bottomleftXInput;
						IN.uv.y += _bottomleftYInput;
					}
					if (IN.vid == 1) {
						IN.uv.x += _bottomrightXInput;
						IN.uv.y += _bottomrightYInput;
					}
					if (IN.vid == 3) {
						IN.uv.x += _toprightXInput;
						IN.uv.y += _toprightYInput;
					}
					if (IN.vid == 2) {
						IN.uv.x += _topleftXInput;
						IN.uv.y += _topleftYInput;
					}
					//IN.vertex += _VertexOffset;


					OUT.position = UnityObjectToClipPos(IN.vertex);
					OUT.uv = IN.uv;
					//OUT.vid = IN.vid;

					return OUT;
				}

				fixed4 fragmentFunc(v2f IN) : SV_Target
				{
					fixed4 pixelColor = tex2D(_MainTex,IN.uv);

					return pixelColor * _Color;
				}

				ENDCG
			}
		}
}