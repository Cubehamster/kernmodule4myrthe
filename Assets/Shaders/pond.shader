// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "pond 1"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_speed("speed", Float) = 1
		_Float0("Float 0", Float) = 0
		_gootDist1("gootDist", Float) = -0.3
		_goot_Smooth1("goot_Smooth", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float _gootDist1;
		uniform float _goot_Smooth1;
		uniform sampler2D _TextureSample0;
		uniform float _speed;
		uniform float _Float0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord27 = v.texcoord.xy * float2( 0,1 );
			float clampResult33 = clamp( ( ( uv_TexCoord27.y + _gootDist1 ) / _goot_Smooth1 ) , 0.0 , 1.0 );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_0 = (_speed).xx;
			float2 panner18 = ( _Time.y * temp_cast_0 + ase_vertexNormal.xy);
			v.vertex.xyz += ( clampResult33 * ( ase_vertexNormal * ( tex2Dlod( _TextureSample0, float4( panner18, 0, 0.0) ).r * _Float0 ) ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
3128;190;1180;655;1722.599;-390.8253;1;True;False
Node;AmplifyShaderEditor.NormalVertexDataNode;22;-1087.569,-41.21717;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1072.633,265.9524;Inherit;False;Property;_speed;speed;1;0;Create;True;0;0;False;0;1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1099.187,350.5699;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1562.906,568.3232;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-839.496,237.88;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1578.103,720.9203;Inherit;False;Property;_gootDist1;gootDist;3;0;Create;True;0;0;False;0;-0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-589.9788,202.4338;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;b8f90c19eb4de6d4cbd90bdf628fad62;b8f90c19eb4de6d4cbd90bdf628fad62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-503.6034,401.0355;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1531.081,847.3802;Inherit;False;Property;_goot_Smooth1;goot_Smooth;4;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1082.95,600.4153;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-255.912,352.3651;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;-816.1895,824.5792;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-75.82507,158.0306;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;33;-551.2015,822.4352;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;111.2994,221.3041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;274.4253,-50.14878;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;pond 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;22;0
WireConnection;18;2;17;0
WireConnection;18;1;15;0
WireConnection;19;1;18;0
WireConnection;31;0;27;2
WireConnection;31;1;28;0
WireConnection;26;0;19;1
WireConnection;26;1;21;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;25;0;22;0
WireConnection;25;1;26;0
WireConnection;33;0;32;0
WireConnection;34;0;33;0
WireConnection;34;1;25;0
WireConnection;0;11;34;0
ASEEND*/
//CHKSM=0339CA392BF5AD5E5A7C1D303E7274D06DFD4651