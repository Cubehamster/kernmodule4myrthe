// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "yokai/blad Boom"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Power("Power", Float) = 1
		_Windspeed("Wind speed", Vector) = (1,0,0,0)
		_maskdist("mask dist", Float) = 1
		_smooth("smooth", Float) = 5.65
		_stencilbuffer("stencil buffer", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "DisableBatching"="True" }
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv2_texcoord2;
		};

		uniform float _stencilbuffer;
		uniform float2 _Windspeed;
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
			float2 uv2_TexCoord6 = v.texcoord1.xy * float2( 1,1 );
			float2 panner7 = ( _Time.y * _Windspeed + uv2_TexCoord6);
			float simplePerlin2D4 = snoise( panner7*1.0 );
			simplePerlin2D4 = simplePerlin2D4*0.5 + 0.5;
			float clampResult43 = clamp( ( ( simplePerlin2D4 * saturate( ( ( ( 1.0 - v.texcoord2.xy.y ) + ( 1.0 - _maskdist ) ) / _smooth ) ) ) * ( _Power / 1000.0 ) ) , -1.0 , 1.0 );
			float3 temp_cast_0 = (clampResult43).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode1 = tex2D( _TextureSample0, i.uv2_texcoord2 );
			o.Albedo = tex2DNode1.rgb;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
2179;111;1286;815;789.0672;-323.6131;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1946.641,859.3738;Inherit;True;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-1792.742,1223.874;Inherit;False;Property;_maskdist;mask dist;4;0;Create;True;0;0;False;0;1;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-1635.358,1049.927;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-1584.742,1200.474;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-1736.001,354.2011;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;10;-1322.001,458.201;Inherit;False;Property;_Windspeed;Wind speed;3;0;Create;True;0;0;False;0;1,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1378.042,996.3739;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1309.001,587.201;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1443.065,344.0684;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1350.742,1269.374;Inherit;False;Property;_smooth;smooth;5;0;Create;True;0;0;False;0;5.65;0.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-1047.865,435.1389;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1183.065,662.6389;Inherit;False;Constant;_noisescale;noise scale;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-1166.141,1060.074;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;4;-811.2648,466.3389;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;-924.914,1023.071;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-368.033,865.0952;Inherit;False;Property;_Power;Power;2;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-341.8901,1016.624;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-429.7029,482.0977;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;39;-147.8901,898.624;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-862.0215,-64.52518;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-138.8926,523.8823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;43;19.5118,479.1145;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-527.5878,-66.37914;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;cb5e98cef2e07044584591d34b85fc28;cb5e98cef2e07044584591d34b85fc28;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-514.4928,801.6918;Inherit;False;Property;_stencilbuffer;stencil buffer;6;0;Create;True;0;0;True;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;248.7021,20.43538;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;yokai/blad Boom;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;True;0;True;31;255;False;26;0;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;1;DisableBatching=True;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;20;2
WireConnection;27;0;25;0
WireConnection;21;0;30;0
WireConnection;21;1;27;0
WireConnection;6;0;8;0
WireConnection;7;0;6;0
WireConnection;7;2;10;0
WireConnection;7;1;9;0
WireConnection;22;0;21;0
WireConnection;22;1;26;0
WireConnection;4;0;7;0
WireConnection;4;1;5;0
WireConnection;24;0;22;0
WireConnection;16;0;4;0
WireConnection;16;1;24;0
WireConnection;39;0;37;0
WireConnection;39;1;40;0
WireConnection;44;0;16;0
WireConnection;44;1;39;0
WireConnection;43;0;44;0
WireConnection;1;1;29;0
WireConnection;0;0;1;0
WireConnection;0;10;1;4
WireConnection;0;11;43;0
ASEEND*/
//CHKSM=BE695999B90EA2840EE218D3BC3CA28FAC10BCFD