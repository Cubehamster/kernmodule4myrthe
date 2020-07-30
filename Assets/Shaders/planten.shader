// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "yokai/planten"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Power("Power", Float) = 0
		_noisescale("noise scale", Float) = 1
		_Windspeed("Wind speed", Vector) = (1,0,0,0)
		_maskdist("mask dist", Float) = 1
		_smooth("smooth", Float) = 0.48
		_stencilbuffer("stencil buffer", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "DisableBatching"="True" }
		Cull Back
		Stencil
		{
			Ref [_stencilbuffer]
			WriteMask 0
			Comp Equal
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _stencilbuffer;
		uniform float2 _Windspeed;
		uniform float _noisescale;
		uniform float _maskdist;
		uniform float _smooth;
		uniform float _Power;
		uniform sampler2D _TextureSample0;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord5 = v.texcoord.xy * float2( 1,1 );
			float2 panner10 = ( _Time.y * _Windspeed + uv_TexCoord5);
			float simplePerlin2D14 = snoise( panner10*_noisescale );
			simplePerlin2D14 = simplePerlin2D14*0.5 + 0.5;
			float clampResult17 = clamp( ( ( simplePerlin2D14 * saturate( ( ( v.texcoord1.xy.y + ( 1.0 - _maskdist ) ) / _smooth ) ) ) * ( _Power / 1000.0 ) ) , -1.0 , 1.0 );
			float3 temp_cast_0 = (clampResult17).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode21 = tex2D( _TextureSample0, i.uv_texcoord );
			o.Albedo = tex2DNode21.rgb;
			o.Alpha = 1;
			clip( tex2DNode21.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
634;159;1286;809;1535.613;789.1068;2.010257;True;True
Node;AmplifyShaderEditor.RangedFloatNode;3;-1823.063,842.9553;Inherit;False;Property;_maskdist;mask dist;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1;-1766.322,-26.71759;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1976.962,478.4551;Inherit;True;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;4;-1615.063,819.5553;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;23;-1352.322,77.28229;Inherit;False;Property;_Windspeed;Wind speed;4;0;Create;True;0;0;False;0;1,0;0.3,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1473.386,-36.85032;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;7;-1339.322,206.2823;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1408.363,615.4552;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1381.063,888.4553;Inherit;False;Property;_smooth;smooth;6;0;Create;True;0;0;False;0;0.48;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-1078.186,54.22018;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1213.386,281.7202;Inherit;False;Property;_noisescale;noise scale;3;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-1196.462,679.1553;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-1009.263,686.9553;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-412.4549,435.7656;Inherit;False;Property;_Power;Power;2;0;Create;True;0;0;False;0;0;1.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;14;-841.5859,85.4202;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-435.9474,526.3957;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-424.4375,132.3868;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-216.9475,401.3957;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-175.4543,262.4621;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-892.3427,-445.4439;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-731.0276,533.901;Inherit;False;Property;_stencilbuffer;stencil buffer;7;0;Create;True;0;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-557.909,-447.2979;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;cb5e98cef2e07044584591d34b85fc28;cb5e98cef2e07044584591d34b85fc28;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;17;-10.30403,200.6609;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-1665.679,669.0083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;211.5992,-122.2862;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;yokai/planten;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;0;True;22;255;False;22;0;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;1;DisableBatching=True;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;5;0;1;0
WireConnection;8;0;2;2
WireConnection;8;1;4;0
WireConnection;10;0;5;0
WireConnection;10;2;23;0
WireConnection;10;1;7;0
WireConnection;15;0;8;0
WireConnection;15;1;9;0
WireConnection;19;0;15;0
WireConnection;14;0;10;0
WireConnection;14;1;11;0
WireConnection;20;0;14;0
WireConnection;20;1;19;0
WireConnection;28;0;26;0
WireConnection;28;1;29;0
WireConnection;30;0;20;0
WireConnection;30;1;28;0
WireConnection;21;1;16;0
WireConnection;17;0;30;0
WireConnection;6;0;2;2
WireConnection;0;0;21;0
WireConnection;0;10;21;4
WireConnection;0;11;17;0
ASEEND*/
//CHKSM=F1249F8D27D635AB573CF4ABC54F53D0C4C31F1B