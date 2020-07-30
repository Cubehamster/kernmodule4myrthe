// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Float0("Float 0", Float) = 0.5
		_Float2("Float 2", Float) = 0.5
		_Float3("Float 3", Float) = 0.5
		_Texuretile("Texure tile", Vector) = (1,1,0,0)
		_Vector4("Vector 4", Vector) = (1,1,0,0)
		_Color0("Color 0", Color) = (1,1,1,0)
		_Base("Base", Range( -1 , 1)) = 0.85
		_BaseColor("BaseColor", Range( -1 , 1)) = 0.85
		_Float1("Float 1", Range( -1 , 1)) = 0.85
		_edgemask("edge mask", Range( -1 , 1)) = 0.85
		_Color2("Color 2", Color) = (0,0,0,0)
		_edgecolormix("edge color mix", Float) = 0
		_aplhafill("aplha fill", Float) = 0
		_Stencile_buffer("Stencile_buffer", Float) = 3
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref [_Stencile_buffer]
			WriteMask 0
			Comp Equal
		}
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv3_texcoord3;
		};

		uniform float _Stencile_buffer;
		uniform float4 _Color0;
		uniform float4 _Color2;
		uniform float _edgecolormix;
		uniform float _edgemask;
		uniform float _BaseColor;
		uniform sampler2D _TextureSample1;
		uniform float _Float3;
		uniform float2 _Texuretile;
		uniform sampler2D _TextureSample3;
		uniform float _Float2;
		uniform float2 _Vector4;
		uniform float _Float1;
		uniform float _Base;
		uniform sampler2D _TextureSample0;
		uniform float _Float0;
		uniform float _aplhafill;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float myVarName155 = 0.0;
			float4 lerpResult35 = lerp( _Color0 , _Color2 , myVarName155);
			float4 color164 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color163 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float temp_output_120_0 = saturate( ( i.vertexColor.r + _edgemask ) );
			float edge159 = temp_output_120_0;
			float4 lerpResult162 = lerp( color164 , color163 , edge159);
			float4 Color140 = ( lerpResult35 + ( _edgecolormix * lerpResult162 ) + ( _edgecolormix * edge159 ) );
			o.Emission = Color140.rgb;
			float mulTime189 = _Time.y * _Float3;
			float2 tilespeed167 = float2( 0,-0.1 );
			float2 texuretile193 = _Texuretile;
			float2 uv3_TexCoord188 = i.uv3_texcoord3 * texuretile193 + float2( 0.5,0 );
			float2 panner191 = ( mulTime189 * -tilespeed167 + uv3_TexCoord188);
			float mulTime130 = _Time.y * _Float2;
			float2 uv3_TexCoord129 = i.uv3_texcoord3 * _Vector4;
			float2 panner134 = ( mulTime130 * -tilespeed167 + uv3_TexCoord129);
			float mulTime82 = _Time.y * _Float0;
			float2 uv3_TexCoord84 = i.uv3_texcoord3 * texuretile193;
			float2 panner85 = ( mulTime82 * tilespeed167 + uv3_TexCoord84);
			float4 Alpha143 = ( ( ( saturate( ( i.vertexColor.b + _BaseColor ) ) * ( tex2D( _TextureSample1, panner191 ) * tex2D( _TextureSample3, panner134 ) ) * saturate( ( i.vertexColor.b + _Float1 ) ) ) + ( temp_output_120_0 + ( saturate( ( i.vertexColor.b + _Base ) ) * tex2D( _TextureSample0, panner85 ) * temp_output_120_0 ) ) ) + _aplhafill );
			o.Alpha = Alpha143.r;
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
				half4 color : COLOR0;
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
				o.customPack1.xy = customInputData.uv3_texcoord3;
				o.customPack1.xy = v.texcoord2;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.uv3_texcoord3 = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
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
2095;103;1286;815;3831.848;1080.12;1.641028;True;True
Node;AmplifyShaderEditor.Vector2Node;83;-3200.171,-956.3889;Inherit;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;0,-0.1;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;187;-3684.392,-1587.841;Inherit;False;Property;_Texuretile;Texure tile;6;0;Create;True;0;0;False;0;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;112;-5101.382,648.7509;Inherit;False;1404.679;654.9082;Comment;5;115;114;113;120;159;edge Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;122;-5131.271,1.015244;Inherit;False;1431.448;646.5887;Comment;11;79;52;50;48;84;82;80;85;74;54;168;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-2946.642,-925.5417;Inherit;False;tilespeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;125;-5143.154,-1156.671;Inherit;False;1431.448;646.5887;Comment;12;136;135;134;133;132;130;129;128;127;126;170;173;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;193;-3492.596,-1579.144;Inherit;False;texuretile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-5037.281,-1247.156;Inherit;False;Property;_Float3;Float 3;5;0;Create;True;0;0;False;0;0.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-5115.585,-1351.964;Inherit;False;167;tilespeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-5008.652,-851.9357;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;0.5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;126;-5093.154,-1106.672;Inherit;False;Property;_Vector4;Vector 4;7;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VertexColorNode;114;-4597.022,836.4609;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;195;-5140.356,61.28981;Inherit;False;193;texuretile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-4684.4,1023.886;Inherit;False;Property;_edgemask;edge mask;12;0;Create;True;0;0;False;0;0.85;-0.17;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-5086.956,-956.7437;Inherit;False;167;tilespeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-5114.486,-1492.158;Inherit;False;193;texuretile;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-4996.769,305.7511;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;188;-4887.06,-1497.384;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;189;-4829.277,-1241.281;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-4858.431,-1102.164;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-4583.312,532.6043;Inherit;False;Property;_Base;Base;9;0;Create;True;0;0;False;0;0.85;-0.55;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;130;-4800.648,-846.0607;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;190;-4856.024,-1341.748;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-4846.549,55.5231;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;82;-4788.765,311.6263;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-4339.418,960.3118;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;173;-4827.395,-946.5285;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;54;-4485.199,360.5733;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;168;-5101.776,185.0619;Inherit;False;167;tilespeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;120;-4171.604,952.1443;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;132;-4497.08,-797.1132;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;134;-4565.027,-983.9583;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;85;-4553.146,173.7286;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;180;-4436.06,-359.167;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-4249.543,427.3592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-4534.172,-187.1367;Inherit;False;Property;_Float1;Float 1;11;0;Create;True;0;0;False;0;0.85;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-4595.193,-625.0828;Inherit;False;Property;_BaseColor;BaseColor;10;0;Create;True;0;0;False;0;0.85;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;191;-4593.656,-1379.178;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;52;-4065.022,378.7735;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-4261.424,-730.3276;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-3907.655,953.1966;Inherit;False;edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;-4304.118,146.9327;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;b8f90c19eb4de6d4cbd90bdf628fad62;52c7cb472d44cdb4185f7ec2ca48e663;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;135;-4316,-1010.754;Inherit;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;-1;b8f90c19eb4de6d4cbd90bdf628fad62;52c7cb472d44cdb4185f7ec2ca48e663;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-4200.404,-292.3814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;184;-4308.935,-1283.403;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;-1;b8f90c19eb4de6d4cbd90bdf628fad62;b8f90c19eb4de6d4cbd90bdf628fad62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;182;-4015.884,-340.9666;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-3875.84,251.3048;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;163;-2697.836,-527.3245;Inherit;False;Constant;_Color1;Color 1;15;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;160;-2825.456,-341.442;Inherit;False;159;edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;136;-4076.905,-778.9128;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;164;-2698.697,-700.1172;Inherit;False;Constant;_Color4;Color 4;15;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-3941.275,-1011.575;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-3643.269,-456.3398;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-3686.657,305.0687;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-2329.155,-262.2282;Inherit;False;Property;_edgecolormix;edge color mix;14;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-2364.89,-778.0701;Inherit;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;162;-2413.228,-548.8958;Inherit;False;3;0;COLOR;1,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;34;-2492.241,-1134.468;Inherit;False;Property;_Color2;Color 2;13;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-2502.068,-957.8065;Inherit;False;Property;_Color0;Color 0;8;0;Create;True;0;0;False;0;1,1,1,0;0.617257,0.7907227,0.9150943,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-2062.8,-198.2957;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-2085.267,-419.9367;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-3399.206,-73.88284;Inherit;False;Property;_aplhafill;aplha fill;15;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-3479.374,-214.455;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;35;-2117.631,-852.8228;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;166;-1775.028,-545.2847;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;175;-3265.022,-223.798;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-1440.49,-553.6636;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-3049.737,-512.1019;Inherit;False;Alpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1214.732,-296.9338;Inherit;False;Property;_Stencile_buffer;Stencile_buffer;16;0;Create;True;0;0;True;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-890.657,-866.8506;Inherit;False;140;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-909.8712,-676.7275;Inherit;False;143;Alpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;23;-697.0777,-862.1887;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;True;3;True;196;255;False;196;0;False;-1;5;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;59;450.8969,499.8901;Inherit;False;100;100;Comment;0;B = overig;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;56;445.6759,232.3728;Inherit;False;100;100;c;0;Groen = mid fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;57;444.3712,365.4788;Inherit;False;100;100;Comment;0;R = edge fade;1,1,1,1;0;0
WireConnection;167;0;83;0
WireConnection;193;0;187;0
WireConnection;188;0;194;0
WireConnection;189;0;186;0
WireConnection;129;0;126;0
WireConnection;130;0;127;0
WireConnection;190;0;185;0
WireConnection;84;0;195;0
WireConnection;82;0;80;0
WireConnection;115;0;114;1
WireConnection;115;1;113;0
WireConnection;173;0;170;0
WireConnection;120;0;115;0
WireConnection;134;0;129;0
WireConnection;134;2;173;0
WireConnection;134;1;130;0
WireConnection;85;0;84;0
WireConnection;85;2;168;0
WireConnection;85;1;82;0
WireConnection;50;0;54;3
WireConnection;50;1;48;0
WireConnection;191;0;188;0
WireConnection;191;2;190;0
WireConnection;191;1;189;0
WireConnection;52;0;50;0
WireConnection;133;0;132;3
WireConnection;133;1;128;0
WireConnection;159;0;120;0
WireConnection;79;1;85;0
WireConnection;135;1;134;0
WireConnection;181;0;180;3
WireConnection;181;1;179;0
WireConnection;184;1;191;0
WireConnection;182;0;181;0
WireConnection;74;0;52;0
WireConnection;74;1;79;0
WireConnection;74;2;120;0
WireConnection;136;0;133;0
WireConnection;192;0;184;0
WireConnection;192;1;135;0
WireConnection;137;0;136;0
WireConnection;137;1;192;0
WireConnection;137;2;182;0
WireConnection;156;0;120;0
WireConnection;156;1;74;0
WireConnection;162;0;164;0
WireConnection;162;1;163;0
WireConnection;162;2;160;0
WireConnection;174;0;158;0
WireConnection;174;1;160;0
WireConnection;157;0;158;0
WireConnection;157;1;162;0
WireConnection;142;0;137;0
WireConnection;142;1;156;0
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;35;2;155;0
WireConnection;166;0;35;0
WireConnection;166;1;157;0
WireConnection;166;2;174;0
WireConnection;175;0;142;0
WireConnection;175;1;176;0
WireConnection;140;0;166;0
WireConnection;143;0;175;0
WireConnection;23;2;141;0
WireConnection;23;9;139;0
ASEEND*/
//CHKSM=2D38E74B39DC60D01B63AB319FBDF379EA8561AE