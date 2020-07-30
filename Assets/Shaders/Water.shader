// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Unlit/water"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_speed("speed", Float) = 1
		_Color1("Color 1", Color) = (0.8490566,0.8490566,0.8490566,0)
		_Color0("Color 0", Color) = (0,0.57473,0.7264151,0)
		_fill("fill", Float) = 0
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[Toggle]_FadeToggle("Fade Toggle", Float) = 0
		_fade_top_distance("fade_top_distance", Float) = 0.85
		_fade_top_Smooth("fade_top_Smooth", Float) = 0.65
		_fade_bottom_distance("fade_bottom_distance", Float) = 0.85
		_fade_bottom_Smooth("fade_bottom_Smooth", Float) = 0.65
		[Toggle]_togglegoot("toggle goot", Float) = 1
		_gootDist("gootDist", Float) = -0.3
		_goot_Smooth("goot_Smooth", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float _speed;
		uniform float2 _Tiling;
		uniform float _fill;
		uniform float _FadeToggle;
		uniform float _togglegoot;
		uniform float _gootDist;
		uniform float _goot_Smooth;
		uniform float _fade_bottom_distance;
		uniform float _fade_bottom_Smooth;
		uniform float _fade_top_distance;
		uniform float _fade_top_Smooth;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (_speed).xx;
			float2 uv_TexCoord48 = i.uv_texcoord * _Tiling;
			float2 panner2 = ( _Time.y * temp_cast_0 + uv_TexCoord48);
			float4 tex2DNode1 = tex2D( _TextureSample0, panner2 );
			float4 lerpResult12 = lerp( _Color0 , _Color1 , tex2DNode1);
			o.Emission = lerpResult12.rgb;
			float2 uv_TexCoord75 = i.uv_texcoord * float2( 0,1 );
			float clampResult89 = clamp( ( ( ( 1.0 - uv_TexCoord75.y ) + _gootDist ) / _goot_Smooth ) , 0.0 , 1.0 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			o.Alpha = ( ( _fill + tex2DNode1 ) * (( _FadeToggle )?( ( saturate( ( ( ase_vertex3Pos.y + _fade_bottom_distance ) / _fade_bottom_Smooth ) ) * ( 1.0 - saturate( ( ( ase_vertex3Pos.y + _fade_top_distance ) / _fade_top_Smooth ) ) ) ) ):( (( _togglegoot )?( clampResult89 ):( 1.0 )) )) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
3145;89;1322;865;1961.034;-1295.467;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;72;-1792.517,1052.488;Inherit;False;1078.852;440.028;Comment;7;61;59;64;62;63;60;66;fade bottom;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;61;-1742.517,1102.488;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;71;-1793.647,597.47;Inherit;False;829.9579;431.6905;Comment;6;55;53;56;54;57;58;Fade top;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1715.203,1277.083;Inherit;False;Property;_fade_top_distance;fade_top_distance;8;0;Create;True;0;0;False;0;0.85;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;75;-1675.95,1545.453;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-1691.147,1698.05;Inherit;False;Property;_gootDist;gootDist;13;0;Create;True;0;0;False;0;-0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1697.3,1377.516;Inherit;False;Property;_fade_top_Smooth;fade_top_Smooth;9;0;Create;True;0;0;False;0;0.65;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-1743.647,647.47;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;93;-1380.034,1571.467;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;-1789.101,7.65839;Inherit;False;843.4661;556.296;Comment;5;68;48;5;6;2;panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1499.886,1183.701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1719.815,820.3239;Inherit;False;Property;_fade_bottom_distance;fade_bottom_distance;10;0;Create;True;0;0;False;0;0.85;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-1356.422,1260.493;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1644.125,1824.51;Inherit;False;Property;_goot_Smooth;goot_Smooth;14;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-1195.994,1577.545;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1721.359,914.1605;Inherit;False;Property;_fade_bottom_Smooth;fade_bottom_Smooth;11;0;Create;True;0;0;False;0;0.65;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-1498.932,734.9366;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;68;-1739.101,68.02298;Inherit;False;Property;_Tiling;Tiling;6;0;Create;True;0;0;False;0;1,1;0.5,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;57;-1345.045,797.1365;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1541.876,453.9544;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1513.589,57.65839;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;60;-1166.812,1195.322;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;85;-929.2333,1801.709;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1580.795,266.2531;Inherit;False;Property;_speed;speed;1;0;Create;True;0;0;False;0;1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-1152.635,277.1853;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;89;-664.2454,1799.565;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;66;-900.6658,1204.398;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;58;-1161.689,759.0638;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-662.0283,1162.443;Inherit;False;Constant;_Float2;Float 2;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;88;-435.805,1162.352;Inherit;False;Property;_togglegoot;toggle goot;12;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-680.1341,482.8753;Inherit;False;Property;_fill;fill;5;0;Create;True;0;0;False;0;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;74;-485.6009,689.1486;Inherit;False;287;188;Comment;1;69;switch;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-718.5344,765.7433;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-894.8788,245.8586;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;b8f90c19eb4de6d4cbd90bdf628fad62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;69;-436.9275,745.7819;Inherit;False;Property;_FadeToggle;Fade Toggle;7;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-641.9274,-172.1367;Inherit;False;Property;_Color1;Color 1;2;0;Create;True;0;0;False;0;0.8490566,0.8490566,0.8490566,0;0.629272,0.6898556,0.745283,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-478.4341,228.8753;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-632.8275,-384.0367;Inherit;False;Property;_Color0;Color 0;3;0;Create;True;0;0;False;0;0,0.57473,0.7264151,0;0,0.57473,0.7264151,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-221.4276,181.3335;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;12;-93.4428,-128.1399;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-500.1853,-177.3572;Inherit;False;Property;_Float1;Float 1;4;0;Create;True;0;0;False;0;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;92;391.4744,-113.4496;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Unlit/water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;93;0;75;2
WireConnection;64;0;61;2
WireConnection;64;1;59;0
WireConnection;63;0;64;0
WireConnection;63;1;62;0
WireConnection;84;0;93;0
WireConnection;84;1;77;0
WireConnection;54;0;53;2
WireConnection;54;1;55;0
WireConnection;57;0;54;0
WireConnection;57;1;56;0
WireConnection;48;0;68;0
WireConnection;60;0;63;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;2;0;48;0
WireConnection;2;2;6;0
WireConnection;2;1;5;0
WireConnection;89;0;85;0
WireConnection;66;0;60;0
WireConnection;58;0;57;0
WireConnection;88;0;70;0
WireConnection;88;1;89;0
WireConnection;67;0;58;0
WireConnection;67;1;66;0
WireConnection;1;1;2;0
WireConnection;69;0;88;0
WireConnection;69;1;67;0
WireConnection;49;0;50;0
WireConnection;49;1;1;0
WireConnection;18;0;49;0
WireConnection;18;1;69;0
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;12;2;1;0
WireConnection;92;2;12;0
WireConnection;92;9;18;0
ASEEND*/
//CHKSM=7D0C9311353655C26F160A7597117142CD0FA469