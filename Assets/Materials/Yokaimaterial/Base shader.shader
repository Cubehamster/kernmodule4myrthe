// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "yokai/Base shader"
{
	Properties
	{
		_UVTiling("UV Tiling", Vector) = (1,1,0,0)
		_Tint("Tint", Color) = (1,1,1,0)
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalPower("Normal Power", Float) = 1
		_Smoothness("Smoothness", Float) = 0
		_Metalness("Metalness", Float) = 0
		_Emmision("Emmision ", Color) = (0,0,0,0)
		_stencilbuffer("stencil buffer", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref [_stencilbuffer]
			WriteMask 0
			Comp Equal
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _stencilbuffer;
		uniform sampler2D _Normal;
		uniform float2 _UVTiling;
		uniform float _NormalPower;
		uniform sampler2D _Albedo;
		uniform float4 _Tint;
		uniform float4 _Emmision;
		uniform float _Metalness;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord20 = i.uv_texcoord * _UVTiling;
			float4 color32 = IsGammaSpace() ? float4(0.1098039,0,1,1) : float4(0.01161224,0,1,1);
			float4 lerpResult33 = lerp( float4( UnpackNormal( tex2D( _Normal, uv_TexCoord20 ) ) , 0.0 ) , color32 , ( 1.0 - _NormalPower ));
			o.Normal = lerpResult33.rgb;
			o.Albedo = ( tex2D( _Albedo, uv_TexCoord20 ) * _Tint ).rgb;
			o.Emission = _Emmision.rgb;
			o.Metallic = _Metalness;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
1981;27;1089;650;2010.514;224.9542;2.809863;True;False
Node;AmplifyShaderEditor.Vector2Node;21;-1880.79,226.468;Inherit;False;Property;_UVTiling;UV Tiling;0;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1598.142,203.6053;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1278.366,707.0795;Inherit;False;Property;_NormalPower;Normal Power;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-656.9286,-49.85061;Inherit;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;False;0;-1;None;c83cb08ae31048744adcf4cca227f981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-597.215,-258.8159;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1306.431,300.6083;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-1266.258,507.6104;Inherit;False;Constant;_Color0;Color 0;9;0;Create;True;0;0;False;0;0.1098039,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;34;-1054.377,700.0259;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-332.2758,483.7555;Inherit;False;Property;_Metalness;Metalness;6;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-381.6898,556.9276;Inherit;False;Property;_Emmision;Emmision ;7;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-283.6895,-20.74902;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-350.2185,410.8702;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-869.3766,399.0259;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-550.38,835.0022;Inherit;False;Property;_stencilbuffer;stencil buffer;8;0;Create;True;0;0;True;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-43.65927,284.7344;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;yokai/Base shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;1;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;0;True;7;255;False;7;0;False;7;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;21;0
WireConnection;16;1;20;0
WireConnection;17;1;20;0
WireConnection;34;0;26;0
WireConnection;28;0;16;0
WireConnection;28;1;27;0
WireConnection;33;0;17;0
WireConnection;33;1;32;0
WireConnection;33;2;34;0
WireConnection;0;0;28;0
WireConnection;0;1;33;0
WireConnection;0;2;24;0
WireConnection;0;3;23;0
WireConnection;0;4;22;0
ASEEND*/
//CHKSM=1E7A8E223F790E7B024A2035B6626EF31C50EF43