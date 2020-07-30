// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ZonPortal"
{
	Properties
	{
		_Location("Location", Vector) = (0.06,0.06,-0.69,0)
		_max("max", Range( -10 , 1)) = -10
		_InnerColor("Inner Color", Color) = (1,1,1,0)
		_OuterColor("Outer Color", Color) = (0.3113208,0,0,0)
		_smoothmin("smoothmin", Range( -1 , 10)) = 0.1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_intens("intens", Float) = 1
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 uv_tex3coord;
		};

		uniform float4 _InnerColor;
		uniform float4 _OuterColor;
		uniform float3 _Location;
		uniform float _max;
		uniform float _smoothmin;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _intens;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 transform24 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float temp_output_125_0 = saturate( ( ( distance( transform24 , float4( _Location , 0.0 ) ) + _max ) / _smoothmin ) );
			float4 lerpResult19 = lerp( _InnerColor , _OuterColor , temp_output_125_0);
			o.Emission = lerpResult19.rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode129 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Alpha = ( ( ( tex2DNode129.r * tex2DNode129.g * tex2DNode129.b * tex2DNode129.a ) * temp_output_125_0 * ( i.uv_tex3coord.z * ( 1.0 - i.uv_tex3coord.z ) ) ) * _intens );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
50;148;1322;866;2650.01;123.8557;1.652729;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-2021.377,383.9655;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;18;-1930.461,552.7081;Inherit;False;Property;_Location;Location;0;0;Create;True;0;0;False;0;0.06,0.06,-0.69;26.82171,3.868459,-42.07496;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;24;-1698.012,368.291;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;16;-1449.461,484.7082;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1248.199,789.2066;Inherit;False;Property;_max;max;1;0;Create;True;0;0;False;0;-10;-1.75;-10;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-794.8607,336.7902;Inherit;False;Property;_smoothmin;smoothmin;4;0;Create;True;0;0;False;0;0.1;1.6;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-866.0678,476.1702;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-244.2168,826.2078;Inherit;True;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;133;8.06221,1059.207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;129;-1463.104,43.10476;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;-1;None;e49430da1d3500e4da2fabc9d1225cdf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;124;-628.426,483.1996;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1116.038,54.60495;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;125;-361.9849,479.8886;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;149.7301,881.6786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;95.30678,-342.833;Inherit;False;Property;_InnerColor;Inner Color;2;0;Create;True;0;0;False;0;1,1,1,0;0.813745,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;94.69589,-184.2297;Inherit;False;Property;_OuterColor;Outer Color;3;0;Create;True;0;0;False;0;0.3113208,0,0,0;0.9529412,0.4789881,0.1568627,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;214.3339,306.997;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;402.7509,341.3273;Inherit;False;Property;_intens;intens;6;0;Create;True;0;0;False;0;1;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;74;-2058.707,-43.33793;Inherit;True;2;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;83;-1429.377,-184.6567;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;50;-1598.666,-316.2806;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;426.497,-136.6192;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;532.9658,223.5139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-1185.891,-215.0729;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1946.222,-326.5101;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;119;709.0207,-68.71539;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Custom/ZonPortal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;15;0
WireConnection;16;0;24;0
WireConnection;16;1;18;0
WireConnection;123;0;16;0
WireConnection;123;1;45;0
WireConnection;133;0;132;3
WireConnection;124;0;123;0
WireConnection;124;1;96;0
WireConnection;130;0;129;1
WireConnection;130;1;129;2
WireConnection;130;2;129;3
WireConnection;130;3;129;4
WireConnection;125;0;124;0
WireConnection;134;0;132;3
WireConnection;134;1;133;0
WireConnection;128;0;130;0
WireConnection;128;1;125;0
WireConnection;128;2;134;0
WireConnection;83;0;50;0
WireConnection;50;0;49;0
WireConnection;50;1;49;0
WireConnection;19;0;21;0
WireConnection;19;1;20;0
WireConnection;19;2;125;0
WireConnection;136;0;128;0
WireConnection;136;1;135;0
WireConnection;51;0;83;0
WireConnection;119;2;19;0
WireConnection;119;9;136;0
ASEEND*/
//CHKSM=058BE7988737911E3C6C597C54C8928A74D4BD85