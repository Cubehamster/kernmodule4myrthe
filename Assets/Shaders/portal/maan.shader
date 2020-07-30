// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/MoonPortal"
{
	Properties
	{
		_Location("Location", Vector) = (0.06,0.06,-0.69,0)
		_max("max", Range( -10 , 1)) = -10
		_InnerColor("Inner Color", Color) = (1,1,1,0)
		_OuterColor("Outer Color", Color) = (0,0.05662018,0.3773585,0)
		_smoothmin("smoothmin", Range( -1 , 10)) = 0.1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_intens("intens", Float) = 0
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
			float4 transform4 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float temp_output_17_0 = saturate( ( ( distance( transform4 , float4( _Location , 0.0 ) ) + _max ) / _smoothmin ) );
			float4 lerpResult18 = lerp( _InnerColor , _OuterColor , temp_output_17_0);
			o.Emission = lerpResult18.rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode21 = tex2D( _TextureSample0, uv_TextureSample0 );
			float temp_output_22_0 = ( tex2DNode21.r * tex2DNode21.g * tex2DNode21.b * tex2DNode21.a );
			float clampResult28 = clamp( ( ( 1.0 - i.uv_tex3coord.z ) * i.uv_tex3coord.z ) , 0.0 , 1.0 );
			o.Alpha = ( ( temp_output_22_0 * temp_output_17_0 * clampResult28 ) * _intens );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
2093;334;1401;655;3006.503;-297.7278;1.079591;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-2873.353,384.6411;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;3;-2782.437,553.3835;Inherit;False;Property;_Location;Location;0;0;Create;True;0;0;False;0;0.06,0.06,-0.69;26.82165,-2.816843,-61.742;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;4;-2549.987,368.9665;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;7;-2301.437,485.3837;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;23;-1302.43,759.3754;Inherit;True;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2100.174,789.882;Inherit;False;Property;_max;max;1;0;Create;True;0;0;False;0;-10;-1.81;-10;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1062.59,751.1492;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1718.043,476.8457;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1646.836,337.4657;Inherit;False;Property;_smoothmin;smoothmin;4;0;Create;True;0;0;False;0;0.1;3.386934;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-1480.401,483.8751;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-854.5671,767.0969;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2291.818,54.5523;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;-1;None;e49430da1d3500e4da2fabc9d1225cdf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;28;-686.5657,759.6255;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1911.821,67.27577;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-1213.96,480.5641;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-513.6272,330.9251;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-758.0847,-342.1575;Inherit;False;Property;_InnerColor;Inner Color;2;0;Create;True;0;0;False;0;1,1,1,0;0,1,0.8044868,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-757.2791,-183.5542;Inherit;False;Property;_OuterColor;Outer Color;3;0;Create;True;0;0;False;0;0,0.05662018,0.3773585,0;0.1568627,0.5907312,0.9529412,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-330.0694,513.3827;Inherit;False;Property;_intens;intens;6;0;Create;True;0;0;False;0;0;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;11;-2488.305,956.8035;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-2731.793,987.2196;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-238.7946,316.4877;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-425.4781,-135.9437;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;19;-2910.683,-42.66241;Inherit;True;2;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1365.694,-47.022;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;13;-1614.35,-7.199781;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-2901.081,855.5958;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-3248.638,845.3663;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Custom/MoonPortal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;0
WireConnection;7;0;4;0
WireConnection;7;1;3;0
WireConnection;24;0;23;3
WireConnection;9;0;7;0
WireConnection;9;1;6;0
WireConnection;12;0;9;0
WireConnection;12;1;10;0
WireConnection;25;0;24;0
WireConnection;25;1;23;3
WireConnection;28;0;25;0
WireConnection;22;0;21;1
WireConnection;22;1;21;2
WireConnection;22;2;21;3
WireConnection;22;3;21;4
WireConnection;17;0;12;0
WireConnection;20;0;22;0
WireConnection;20;1;17;0
WireConnection;20;2;28;0
WireConnection;11;0;8;0
WireConnection;8;0;5;0
WireConnection;26;0;20;0
WireConnection;26;1;27;0
WireConnection;18;0;15;0
WireConnection;18;1;16;0
WireConnection;18;2;17;0
WireConnection;14;0;13;0
WireConnection;14;1;13;0
WireConnection;14;2;13;0
WireConnection;13;0;22;0
WireConnection;5;0;2;0
WireConnection;5;1;2;0
WireConnection;0;2;18;0
WireConnection;0;9;26;0
ASEEND*/
//CHKSM=C0C08C88C3A8EFDF73CFD87E5EA50DFA76D55FA0