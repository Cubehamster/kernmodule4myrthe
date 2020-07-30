// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "yokai/meeps"
{
	Properties
	{
		_Albedo("Albedo", Color) = (0,0,0,0)
		_emmisionpower("emmision power", Float) = 0
		_EmmisionTexture("Emmision Texture ", 2D) = "white" {}
		_emmisionColor("emmision Color", Color) = (0,0,0,0)
		_stencilbuffer("stencil buffer", Float) = 0
		[Toggle]_Texturecolor("Texture/color", Float) = 0
		_albedo("albedo", 2D) = "white" {}
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
		uniform float _Texturecolor;
		uniform sampler2D _albedo;
		uniform float4 _albedo_ST;
		uniform float4 _Albedo;
		uniform float4 _emmisionColor;
		uniform float _emmisionpower;
		uniform sampler2D _EmmisionTexture;
		uniform float4 _EmmisionTexture_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_albedo = i.uv_texcoord * _albedo_ST.xy + _albedo_ST.zw;
			o.Albedo = (( _Texturecolor )?( _Albedo ):( tex2D( _albedo, uv_albedo ) )).rgb;
			float2 uv_EmmisionTexture = i.uv_texcoord * _EmmisionTexture_ST.xy + _EmmisionTexture_ST.zw;
			o.Emission = ( _emmisionColor * _emmisionpower * tex2D( _EmmisionTexture, uv_EmmisionTexture ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
3162;284;1089;649;1356.635;89.5879;1.349672;True;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-718.3906,303.2798;Inherit;False;Property;_emmisionpower;emmision power;1;0;Create;True;0;0;False;0;0;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-708.3907,87.27985;Inherit;False;Property;_emmisionColor;emmision Color;3;0;Create;True;0;0;False;0;0,0,0,0;0.940598,0.9622642,0.4627451,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-1062.497,-146.4664;Inherit;False;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-941.9111,-397.433;Inherit;True;Property;_albedo;albedo;6;0;Create;True;0;0;False;0;-1;None;0d2c8c242174cee4fa1c430406ad8517;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-847.0579,516.0871;Inherit;True;Property;_EmmisionTexture;Emmision Texture ;2;0;Create;True;0;0;False;0;-1;None;0d2c8c242174cee4fa1c430406ad8517;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;-251.5,528.5;Inherit;False;Property;_stencilbuffer;stencil buffer;4;0;Create;True;0;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-327.3907,237.2798;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;7;-428.8831,-201.3978;Inherit;False;Property;_Texturecolor;Texture/color;5;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;yokai/meeps;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;0;True;1;255;False;-1;0;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;5;2;3;0
WireConnection;7;0;8;0
WireConnection;7;1;2;0
WireConnection;0;0;7;0
WireConnection;0;2;5;0
ASEEND*/
//CHKSM=0F9BE7166411E4E3195AEA911B32EB7FD1C30BEF