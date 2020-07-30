// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Refract Zon"
{
	Properties
	{
		_Material_Location("Material_Location", Vector) = (0.06,0.06,-0.69,0)
		_Fade_Color("Fade_Color", Color) = (0.8392157,0.1187232,0.003921559,0)
		_Intensity("Intensity", Range( 0 , 1)) = 4
		_Fade_range("Fade_range", Range( -4 , 1)) = -0.3734269
		_Fade_smooth("Fade_smooth", Range( -1 , 10)) = 3.37
		_refraction_amount("refraction_amount", Float) = 0
		_Vertex_offset("Vertex_offset", Float) = 1
		_Noise_Texture("Noise_Texture", 2D) = "white" {}
		_Noise_Direction("Noise_Direction", Vector) = (0,0.1,0,0)
		_Noise_Speed("Noise_Speed", Float) = 0.5
		_Noise_Tile("Noise_Tile", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float3 viewDir;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Noise_Texture;
		uniform float _Noise_Speed;
		uniform float2 _Noise_Direction;
		uniform float2 _Noise_Tile;
		uniform float _refraction_amount;
		uniform float _Intensity;
		uniform float _Vertex_offset;
		uniform float3 _Material_Location;
		uniform float _Fade_range;
		uniform float _Fade_smooth;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float4 _Fade_Color;


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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime58 = _Time.y * _Noise_Speed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv2_TexCoord55 = v.texcoord1.xy * _Noise_Tile;
			float2 panner63 = ( mulTime58 * _Noise_Direction + refract( -ase_worldViewDir , float3( uv2_TexCoord55 ,  0.0 ) , _refraction_amount ).xy);
			float simplePerlin2D65 = snoise( panner63*2.0 );
			simplePerlin2D65 = simplePerlin2D65*0.5 + 0.5;
			float4 temp_output_75_0 = ( tex2Dlod( _Noise_Texture, float4( panner63, 0, 0.0) ) * ( simplePerlin2D65 * _Intensity ) * simplePerlin2D65 );
			float temp_output_67_0 = saturate( ( ( distance( ase_worldPos , _Material_Location ) + _Fade_range ) / _Fade_smooth ) );
			float4 temp_cast_2 = (_Vertex_offset).xxxx;
			float4 clampResult80 = clamp( ( temp_output_75_0 * _Vertex_offset * ( 1.0 - temp_output_67_0 ) ) , float4( 0,0,0,0 ) , temp_cast_2 );
			v.vertex.xyz += clampResult80.rgb;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor77 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPos.xy/ase_grabScreenPos.w);
			float mulTime58 = _Time.y * _Noise_Speed;
			float2 uv2_TexCoord55 = i.uv2_texcoord2 * _Noise_Tile;
			float2 panner63 = ( mulTime58 * _Noise_Direction + refract( -i.viewDir , float3( uv2_TexCoord55 ,  0.0 ) , _refraction_amount ).xy);
			float simplePerlin2D65 = snoise( panner63*2.0 );
			simplePerlin2D65 = simplePerlin2D65*0.5 + 0.5;
			float4 temp_output_75_0 = ( tex2D( _Noise_Texture, panner63 ) * ( simplePerlin2D65 * _Intensity ) * simplePerlin2D65 );
			float4 color73 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_worldPos = i.worldPos;
			float temp_output_67_0 = saturate( ( ( distance( ase_worldPos , _Material_Location ) + _Fade_range ) / _Fade_smooth ) );
			float4 lerpResult76 = lerp( color73 , _Fade_Color , temp_output_67_0);
			o.Emission = ( screenColor77 + temp_output_75_0 + lerpResult76 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
2996;217;1370;767;3517.396;-612.5104;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;47;-3236.676,693.1339;Inherit;False;1914.728;516.4161;Comment;9;81;67;64;62;61;60;56;51;50;fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;48;-2739.635,-24.12593;Inherit;False;Property;_Noise_Tile;Noise_Tile;10;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;49;-2742.82,-271.8296;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;51;-3186.676,790.3098;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;52;-2520.352,404.4825;Inherit;False;Property;_Noise_Speed;Noise_Speed;9;0;Create;True;0;0;False;0;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2502.901,107.8406;Inherit;False;Property;_refraction_amount;refraction_amount;5;0;Create;True;0;0;False;0;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;54;-2420.432,-152.2669;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-2504.913,-35.76569;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;50;-3095.759,959.0518;Inherit;False;Property;_Material_Location;Material_Location;0;0;Create;True;0;0;False;0;0.06,0.06,-0.69;5.654966,0.2457515,-9.756899;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;56;-2614.757,891.0518;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RefractOpVec;57;-2204.549,-3.528701;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;58;-2302.849,407.3875;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;59;-2337.505,278.8051;Inherit;False;Property;_Noise_Direction;Noise_Direction;8;0;Create;True;0;0;False;0;0,0.1;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;60;-2391.494,1094.55;Inherit;False;Property;_Fade_range;Fade_range;3;0;Create;True;0;0;False;0;-0.3734269;-2.51;-4;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-2031.363,882.5139;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;63;-1978.127,224.9382;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2108.69,744.9678;Inherit;False;Property;_Fade_smooth;Fade_smooth;4;0;Create;True;0;0;False;0;3.37;0.65;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;64;-1793.721,889.5438;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1472.186,74.93758;Inherit;False;Property;_Intensity;Intensity;2;0;Create;True;0;0;False;0;4;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;65;-1603.02,-166.2748;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;70;-1253.597,874.0108;Inherit;False;599.8755;516.1099;Comment;3;76;73;71;fade color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;69;-1476.018,207.0975;Inherit;True;Property;_Noise_Texture;Noise_Texture;7;0;Create;True;0;0;False;0;-1;b8f90c19eb4de6d4cbd90bdf628fad62;b8f90c19eb4de6d4cbd90bdf628fad62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;67;-1519.948,890.5068;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1278.204,-170.2395;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;-817.4758,361.5644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;71;-1203.597,1097.192;Inherit;False;Property;_Fade_Color;Fade_Color;1;0;Create;True;0;0;False;0;0.8392157,0.1187232,0.003921559,0;0.8392157,0.3031469,0.003921559,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-807.6276,444.6754;Inherit;False;Property;_Vertex_offset;Vertex_offset;6;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;73;-1191.504,924.0108;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-957.4072,-171.5119;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;76;-837.7214,1234.121;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;77;-999.2822,-378.3177;Inherit;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-633.6045,314.6157;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;81;-2863.306,774.6348;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;80;-403.1518,343.1989;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-426.3395,-162.5754;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Refract Zon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;49;0
WireConnection;55;0;48;0
WireConnection;56;0;51;0
WireConnection;56;1;50;0
WireConnection;57;0;54;0
WireConnection;57;1;55;0
WireConnection;57;2;53;0
WireConnection;58;0;52;0
WireConnection;61;0;56;0
WireConnection;61;1;60;0
WireConnection;63;0;57;0
WireConnection;63;2;59;0
WireConnection;63;1;58;0
WireConnection;64;0;61;0
WireConnection;64;1;62;0
WireConnection;65;0;63;0
WireConnection;69;1;63;0
WireConnection;67;0;64;0
WireConnection;68;0;65;0
WireConnection;68;1;66;0
WireConnection;74;0;67;0
WireConnection;75;0;69;0
WireConnection;75;1;68;0
WireConnection;75;2;65;0
WireConnection;76;0;73;0
WireConnection;76;1;71;0
WireConnection;76;2;67;0
WireConnection;78;0;75;0
WireConnection;78;1;72;0
WireConnection;78;2;74;0
WireConnection;81;0;51;0
WireConnection;80;0;78;0
WireConnection;80;2;72;0
WireConnection;79;0;77;0
WireConnection;79;1;75;0
WireConnection;79;2;76;0
WireConnection;0;2;79;0
WireConnection;0;11;80;0
ASEEND*/
//CHKSM=2FF548FD50C9D844BDECE785E577786B6CC7B0A9