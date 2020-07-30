// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Refract"
{
	Properties
	{
		_Location("Location", Vector) = (0.06,0.06,-0.69,0)
		_GlowColor("GlowColor", Color) = (0.8392157,0.1187232,0.003921559,0)
		_GlowRange("GlowRange", Range( -4 , 1)) = -0.3734269
		_Intensity("Intensity", Range( 0 , 1)) = 1
		_GlowSmooth("GlowSmooth", Range( -1 , 10)) = 3.37
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
		uniform float _Vertex_offset;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Intensity;
		uniform float4 _GlowColor;
		uniform float3 _Location;
		uniform float _GlowRange;
		uniform float _GlowSmooth;


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
			float mulTime4 = _Time.y * _Noise_Speed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv2_TexCoord6 = v.texcoord1.xy * _Noise_Tile;
			float2 panner5 = ( mulTime4 * _Noise_Direction + refract( -ase_worldViewDir , float3( uv2_TexCoord6 ,  0.0 ) , _refraction_amount ).xy);
			float4 tex2DNode18 = tex2Dlod( _Noise_Texture, float4( panner5, 0, 0.0) );
			float clampResult59 = clamp( 0.0 , tex2DNode18.r , _Vertex_offset );
			float3 temp_cast_3 = (clampResult59).xxx;
			v.vertex.xyz += temp_cast_3;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor21 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPos.xy/ase_grabScreenPos.w);
			float mulTime4 = _Time.y * _Noise_Speed;
			float2 uv2_TexCoord6 = i.uv2_texcoord2 * _Noise_Tile;
			float2 panner5 = ( mulTime4 * _Noise_Direction + refract( -i.viewDir , float3( uv2_TexCoord6 ,  0.0 ) , _refraction_amount ).xy);
			float simplePerlin2D31 = snoise( panner5*2.0 );
			simplePerlin2D31 = simplePerlin2D31*0.5 + 0.5;
			float4 tex2DNode18 = tex2D( _Noise_Texture, panner5 );
			float4 Noise133 = ( ( simplePerlin2D31 * _Intensity ) * tex2DNode18 );
			float4 color105 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_worldPos = i.worldPos;
			float4 lerpResult106 = lerp( color105 , _GlowColor , saturate( ( ( distance( ase_worldPos , _Location ) + _GlowRange ) / _GlowSmooth ) ));
			float4 ZonFadeColor126 = lerpResult106;
			o.Emission = ( screenColor21 + Noise133 + ZonFadeColor126 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
2093;334;1401;655;4528.151;506.4658;3.573317;True;False
Node;AmplifyShaderEditor.CommentaryNode;132;-2303.23,971.9078;Inherit;False;2065.239;807.2065;Noice;15;54;9;12;6;10;19;7;8;4;5;36;31;18;52;44;noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;9;-2228.415,1174.799;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;54;-2253.23,1357.503;Inherit;False;Property;_Noise_Tile;Noise_Tile;10;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;108;-2283.045,-173.6814;Inherit;False;1396.062;542.3494;Comment;8;73;72;75;70;71;69;68;67;Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;10;-1926.027,1252.361;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2018.508,1345.863;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-2004.496,1474.469;Inherit;False;Property;_refraction_amount;refraction_amount;5;0;Create;True;0;0;False;0;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1832.064,1664.114;Inherit;False;Property;_Noise_Speed;Noise_Speed;9;0;Create;True;0;0;False;0;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;67;-2233.045,-76.50581;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;68;-2142.128,92.23669;Inherit;False;Property;_Location;Location;0;0;Create;True;0;0;False;0;0.06,0.06,-0.69;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;75;-1819.02,89.60848;Inherit;False;Property;_GlowRange;GlowRange;2;0;Create;True;0;0;False;0;-0.3734269;-2.51;-4;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1624.767,1661.98;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;7;-1653.1,1513.433;Inherit;False;Property;_Noise_Direction;Noise_Direction;8;0;Create;True;0;0;False;0;0,0.1;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RefractOpVec;8;-1696.144,1359.1;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;69;-1818.483,-96.40501;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1630.63,247.0712;Inherit;False;Property;_GlowSmooth;GlowSmooth;4;0;Create;True;0;0;False;0;3.37;0.65;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;5;-1417.723,1491.567;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-1541.066,-35.00612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1169.672,1263.357;Inherit;False;Property;_Intensity;Intensity;3;0;Create;True;0;0;False;0;1;0.352;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;31;-1188.911,1021.908;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;72;-1348.883,-22.73062;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-743.1008,-111.6845;Inherit;False;599.8755;516.1099;Comment;3;107;105;106;fade color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;73;-1138.053,-23.51632;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-814.0743,1178.248;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-681.0078,-61.68405;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;107;-693.1008,111.4959;Inherit;False;Property;_GlowColor;GlowColor;1;0;Create;True;0;0;False;0;0.8392157,0.1187232,0.003921559,0;1,0.4768409,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-881.5504,1455.709;Inherit;True;Property;_Noise_Texture;Noise_Texture;7;0;Create;True;0;0;False;0;-1;b8f90c19eb4de6d4cbd90bdf628fad62;b8f90c19eb4de6d4cbd90bdf628fad62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-472.9917,1037.975;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;106;-364.955,257.0999;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-215.5422,1031.039;Inherit;False;Noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-70.21016,247.0094;Inherit;False;ZonFadeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;309.6112,836.0792;Inherit;False;126;ZonFadeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;58;1044.959,1181.826;Inherit;False;Property;_Vertex_offset;Vertex_offset;6;0;Create;True;0;0;False;0;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;329.5258,722.1801;Inherit;False;133;Noise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;21;401.7299,480.6336;Inherit;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-1369.69,-545.985;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;736.1599,715.9802;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;59;1268.39,1076.985;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-1777.293,-636.1326;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;1,1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;82;1749.509,698.2357;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Refract;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;0
WireConnection;6;0;54;0
WireConnection;4;0;19;0
WireConnection;8;0;10;0
WireConnection;8;1;6;0
WireConnection;8;2;12;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;5;0;8;0
WireConnection;5;2;7;0
WireConnection;5;1;4;0
WireConnection;71;0;69;0
WireConnection;71;1;75;0
WireConnection;31;0;5;0
WireConnection;72;0;71;0
WireConnection;72;1;70;0
WireConnection;73;0;72;0
WireConnection;52;0;31;0
WireConnection;52;1;36;0
WireConnection;18;1;5;0
WireConnection;44;0;52;0
WireConnection;44;1;18;0
WireConnection;106;0;105;0
WireConnection;106;1;107;0
WireConnection;106;2;73;0
WireConnection;133;0;44;0
WireConnection;126;0;106;0
WireConnection;22;0;21;0
WireConnection;22;1;134;0
WireConnection;22;2;127;0
WireConnection;59;1;18;0
WireConnection;59;2;58;0
WireConnection;82;2;22;0
WireConnection;82;11;59;0
ASEEND*/
//CHKSM=A8EB6D398CA3AA27CC96B2635D258ABB60D522A9