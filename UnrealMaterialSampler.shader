Shader "Shader Graphs/UnrealMaterialSampler"
{
    Properties
    {
        [NoScaleOffset]_Base("Base", 2D) = "white" {}
        _BaseColor("BaseColor", Color) = (1, 1, 1, 1)
        [ToggleUI]_Emmit("Emmit", Float) = 0
        [NoScaleOffset]_Emmission("Emmission", 2D) = "white" {}
        [HDR]_E_Intensity("E_Intensity", Color) = (0, 0, 0, 0)
        [NoScaleOffset]_Normal("Normal", 2D) = "white" {}
        _N_Intensity("N_Intensity", Range(0, 1)) = 1
        [NoScaleOffset]_ORM("ORM", 2D) = "white" {}
        _AOIntensity("AOIntensity", Range(0, 1)) = 1
        _Smoothness_Intensity("Rughness_Intensity", Range(0, 1)) = 0.5
        _MetallicAmount("MetallicAmount", Range(0, 1)) = 1
        [NoScaleOffset]_Alpha("Alpha", 2D) = "white" {}
        _A_Clip("A_Clip", Float) = 0.5
        _Opacity("Opacity", Float) = 1
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 1
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 1
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 1
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        AlphaToMask [_AlphaToMask]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.tex, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.samplerstate, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_R_4_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.r;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_G_5_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.g;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_B_6_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.b;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_A_7_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.a;
            float4 _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4, _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4, _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4);
            UnityTexture2D _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            float4 _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.tex, _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.samplerstate, _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4);
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_R_4_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.r;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_G_5_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.g;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_B_6_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.b;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_A_7_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.a;
            float4 _Combine_4d363590b3c9428d98d225ea96ac882f_RGBA_4_Vector4;
            float3 _Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3;
            float2 _Combine_4d363590b3c9428d98d225ea96ac882f_RG_6_Vector2;
            Unity_Combine_float(_SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_R_4_Float, _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_G_5_Float, _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_B_6_Float, float(0), _Combine_4d363590b3c9428d98d225ea96ac882f_RGBA_4_Vector4, _Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3, _Combine_4d363590b3c9428d98d225ea96ac882f_RG_6_Vector2);
            float _Property_bf0a11a0c34044aa97096e76d43526b2_Out_0_Float = _N_Intensity;
            float3 _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3, _Property_bf0a11a0c34044aa97096e76d43526b2_Out_0_Float, _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3);
            float _Property_0f30bcb3db7546c9858ee2561fd886af_Out_0_Boolean = _Emmit;
            UnityTexture2D _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emmission);
            float4 _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.tex, _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.samplerstate, _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_R_4_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.r;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_G_5_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.g;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_B_6_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.b;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_A_7_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.a;
            float4 _Property_0e63c2d5c5e049dbbd1bdb87dfff74ba_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_E_Intensity) : _E_Intensity;
            float4 _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4, _Property_0e63c2d5c5e049dbbd1bdb87dfff74ba_Out_0_Vector4, _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4);
            float4 _Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4;
            Unity_Branch_float4(_Property_0f30bcb3db7546c9858ee2561fd886af_Out_0_Boolean, _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4, float4(0, 0, 0, 0), _Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4);
            UnityTexture2D _Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ORM);
            float4 _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D.tex, _Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D.samplerstate, _Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_R_4_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.r;
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_G_5_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.g;
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_B_6_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.b;
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_A_7_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.a;
            float _Preview_25ed2128133d4d638c15cbd4e95d5c20_Out_1_Float;
            Unity_Preview_float(_SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_B_6_Float, _Preview_25ed2128133d4d638c15cbd4e95d5c20_Out_1_Float);
            float _Property_2691d8dc23b249ccb88eb3d4278b6617_Out_0_Float = _MetallicAmount;
            float _Multiply_a89a289528464483bf047f907c80ff85_Out_2_Float;
            Unity_Multiply_float_float(_Preview_25ed2128133d4d638c15cbd4e95d5c20_Out_1_Float, _Property_2691d8dc23b249ccb88eb3d4278b6617_Out_0_Float, _Multiply_a89a289528464483bf047f907c80ff85_Out_2_Float);
            float _Preview_8f1704cf855846a4a43dda0c56cfd307_Out_1_Float;
            Unity_Preview_float(_SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_G_5_Float, _Preview_8f1704cf855846a4a43dda0c56cfd307_Out_1_Float);
            float _OneMinus_0bcd7ef2aee341148a36acf097c62cf0_Out_1_Float;
            Unity_OneMinus_float(_Preview_8f1704cf855846a4a43dda0c56cfd307_Out_1_Float, _OneMinus_0bcd7ef2aee341148a36acf097c62cf0_Out_1_Float);
            float _Property_57090decc1554312a29ee16f45ff27e8_Out_0_Float = _Smoothness_Intensity;
            float _Multiply_2679e40fddea4b2fb21a86665421b467_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_0bcd7ef2aee341148a36acf097c62cf0_Out_1_Float, _Property_57090decc1554312a29ee16f45ff27e8_Out_0_Float, _Multiply_2679e40fddea4b2fb21a86665421b467_Out_2_Float);
            float _Saturate_c9b1d34ab60049808507fb30189a43b6_Out_1_Float;
            Unity_Saturate_float(_Multiply_2679e40fddea4b2fb21a86665421b467_Out_2_Float, _Saturate_c9b1d34ab60049808507fb30189a43b6_Out_1_Float);
            float _Preview_982d9b1d96654bac8a2d19bb98692c1c_Out_1_Float;
            Unity_Preview_float(_SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_R_4_Float, _Preview_982d9b1d96654bac8a2d19bb98692c1c_Out_1_Float);
            float _Property_f2a4fbad8d234108adf9e8f91de9e442_Out_0_Float = _AOIntensity;
            float _Remap_90c0aa4e3d0d478dab64f6980b240053_Out_3_Float;
            Unity_Remap_float(_Property_f2a4fbad8d234108adf9e8f91de9e442_Out_0_Float, float2 (0, 1), float2 (1, 0), _Remap_90c0aa4e3d0d478dab64f6980b240053_Out_3_Float);
            float _Add_d8f1ca73f8694e5a9cebcbd8318dfe98_Out_2_Float;
            Unity_Add_float(_Preview_982d9b1d96654bac8a2d19bb98692c1c_Out_1_Float, _Remap_90c0aa4e3d0d478dab64f6980b240053_Out_3_Float, _Add_d8f1ca73f8694e5a9cebcbd8318dfe98_Out_2_Float);
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.BaseColor = (_Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4.xyz);
            surface.NormalTS = _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3;
            surface.Emission = (_Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4.xyz);
            surface.Metallic = _Multiply_a89a289528464483bf047f907c80ff85_Out_2_Float;
            surface.Specular = IsGammaSpace() ? float3(0.509434, 0.509434, 0.509434) : SRGBToLinear(float3(0.509434, 0.509434, 0.509434));
            surface.Smoothness = _Saturate_c9b1d34ab60049808507fb30189a43b6_Out_1_Float;
            surface.Occlusion = _Add_d8f1ca73f8694e5a9cebcbd8318dfe98_Out_2_Float;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.tex, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.samplerstate, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_R_4_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.r;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_G_5_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.g;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_B_6_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.b;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_A_7_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.a;
            float4 _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4, _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4, _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4);
            UnityTexture2D _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            float4 _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.tex, _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.samplerstate, _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4);
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_R_4_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.r;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_G_5_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.g;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_B_6_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.b;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_A_7_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.a;
            float4 _Combine_4d363590b3c9428d98d225ea96ac882f_RGBA_4_Vector4;
            float3 _Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3;
            float2 _Combine_4d363590b3c9428d98d225ea96ac882f_RG_6_Vector2;
            Unity_Combine_float(_SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_R_4_Float, _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_G_5_Float, _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_B_6_Float, float(0), _Combine_4d363590b3c9428d98d225ea96ac882f_RGBA_4_Vector4, _Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3, _Combine_4d363590b3c9428d98d225ea96ac882f_RG_6_Vector2);
            float _Property_bf0a11a0c34044aa97096e76d43526b2_Out_0_Float = _N_Intensity;
            float3 _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3, _Property_bf0a11a0c34044aa97096e76d43526b2_Out_0_Float, _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3);
            float _Property_0f30bcb3db7546c9858ee2561fd886af_Out_0_Boolean = _Emmit;
            UnityTexture2D _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emmission);
            float4 _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.tex, _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.samplerstate, _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_R_4_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.r;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_G_5_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.g;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_B_6_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.b;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_A_7_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.a;
            float4 _Property_0e63c2d5c5e049dbbd1bdb87dfff74ba_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_E_Intensity) : _E_Intensity;
            float4 _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4, _Property_0e63c2d5c5e049dbbd1bdb87dfff74ba_Out_0_Vector4, _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4);
            float4 _Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4;
            Unity_Branch_float4(_Property_0f30bcb3db7546c9858ee2561fd886af_Out_0_Boolean, _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4, float4(0, 0, 0, 0), _Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4);
            UnityTexture2D _Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ORM);
            float4 _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D.tex, _Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D.samplerstate, _Property_23000204859a46e5b6a91b987f234637_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_R_4_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.r;
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_G_5_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.g;
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_B_6_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.b;
            float _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_A_7_Float = _SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_RGBA_0_Vector4.a;
            float _Preview_25ed2128133d4d638c15cbd4e95d5c20_Out_1_Float;
            Unity_Preview_float(_SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_B_6_Float, _Preview_25ed2128133d4d638c15cbd4e95d5c20_Out_1_Float);
            float _Property_2691d8dc23b249ccb88eb3d4278b6617_Out_0_Float = _MetallicAmount;
            float _Multiply_a89a289528464483bf047f907c80ff85_Out_2_Float;
            Unity_Multiply_float_float(_Preview_25ed2128133d4d638c15cbd4e95d5c20_Out_1_Float, _Property_2691d8dc23b249ccb88eb3d4278b6617_Out_0_Float, _Multiply_a89a289528464483bf047f907c80ff85_Out_2_Float);
            float _Preview_8f1704cf855846a4a43dda0c56cfd307_Out_1_Float;
            Unity_Preview_float(_SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_G_5_Float, _Preview_8f1704cf855846a4a43dda0c56cfd307_Out_1_Float);
            float _OneMinus_0bcd7ef2aee341148a36acf097c62cf0_Out_1_Float;
            Unity_OneMinus_float(_Preview_8f1704cf855846a4a43dda0c56cfd307_Out_1_Float, _OneMinus_0bcd7ef2aee341148a36acf097c62cf0_Out_1_Float);
            float _Property_57090decc1554312a29ee16f45ff27e8_Out_0_Float = _Smoothness_Intensity;
            float _Multiply_2679e40fddea4b2fb21a86665421b467_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_0bcd7ef2aee341148a36acf097c62cf0_Out_1_Float, _Property_57090decc1554312a29ee16f45ff27e8_Out_0_Float, _Multiply_2679e40fddea4b2fb21a86665421b467_Out_2_Float);
            float _Saturate_c9b1d34ab60049808507fb30189a43b6_Out_1_Float;
            Unity_Saturate_float(_Multiply_2679e40fddea4b2fb21a86665421b467_Out_2_Float, _Saturate_c9b1d34ab60049808507fb30189a43b6_Out_1_Float);
            float _Preview_982d9b1d96654bac8a2d19bb98692c1c_Out_1_Float;
            Unity_Preview_float(_SampleTexture2D_83d143eaf2404bdca02f407841cf43bf_R_4_Float, _Preview_982d9b1d96654bac8a2d19bb98692c1c_Out_1_Float);
            float _Property_f2a4fbad8d234108adf9e8f91de9e442_Out_0_Float = _AOIntensity;
            float _Remap_90c0aa4e3d0d478dab64f6980b240053_Out_3_Float;
            Unity_Remap_float(_Property_f2a4fbad8d234108adf9e8f91de9e442_Out_0_Float, float2 (0, 1), float2 (1, 0), _Remap_90c0aa4e3d0d478dab64f6980b240053_Out_3_Float);
            float _Add_d8f1ca73f8694e5a9cebcbd8318dfe98_Out_2_Float;
            Unity_Add_float(_Preview_982d9b1d96654bac8a2d19bb98692c1c_Out_1_Float, _Remap_90c0aa4e3d0d478dab64f6980b240053_Out_3_Float, _Add_d8f1ca73f8694e5a9cebcbd8318dfe98_Out_2_Float);
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.BaseColor = (_Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4.xyz);
            surface.NormalTS = _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3;
            surface.Emission = (_Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4.xyz);
            surface.Metallic = _Multiply_a89a289528464483bf047f907c80ff85_Out_2_Float;
            surface.Specular = IsGammaSpace() ? float3(0.509434, 0.509434, 0.509434) : SRGBToLinear(float3(0.509434, 0.509434, 0.509434));
            surface.Smoothness = _Saturate_c9b1d34ab60049808507fb30189a43b6_Out_1_Float;
            surface.Occlusion = _Add_d8f1ca73f8694e5a9cebcbd8318dfe98_Out_2_Float;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            float4 _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.tex, _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.samplerstate, _Property_fdbbebd0d57946a09a0786c18a2545c4_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4);
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_R_4_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.r;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_G_5_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.g;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_B_6_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.b;
            float _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_A_7_Float = _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_RGBA_0_Vector4.a;
            float4 _Combine_4d363590b3c9428d98d225ea96ac882f_RGBA_4_Vector4;
            float3 _Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3;
            float2 _Combine_4d363590b3c9428d98d225ea96ac882f_RG_6_Vector2;
            Unity_Combine_float(_SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_R_4_Float, _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_G_5_Float, _SampleTexture2D_f7ab786afb544f24863ef68d45dbb7cc_B_6_Float, float(0), _Combine_4d363590b3c9428d98d225ea96ac882f_RGBA_4_Vector4, _Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3, _Combine_4d363590b3c9428d98d225ea96ac882f_RG_6_Vector2);
            float _Property_bf0a11a0c34044aa97096e76d43526b2_Out_0_Float = _N_Intensity;
            float3 _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_4d363590b3c9428d98d225ea96ac882f_RGB_5_Vector3, _Property_bf0a11a0c34044aa97096e76d43526b2_Out_0_Float, _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3);
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.NormalTS = _NormalStrength_8fb1b8159fb44e6a88020079f867a4cc_Out_2_Vector3;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.tex, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.samplerstate, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_R_4_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.r;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_G_5_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.g;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_B_6_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.b;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_A_7_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.a;
            float4 _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4, _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4, _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4);
            float _Property_0f30bcb3db7546c9858ee2561fd886af_Out_0_Boolean = _Emmit;
            UnityTexture2D _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emmission);
            float4 _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.tex, _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.samplerstate, _Property_b501e7074e55445ba896b7957fe0f302_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_R_4_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.r;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_G_5_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.g;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_B_6_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.b;
            float _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_A_7_Float = _SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4.a;
            float4 _Property_0e63c2d5c5e049dbbd1bdb87dfff74ba_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_E_Intensity) : _E_Intensity;
            float4 _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_036b7c91243341bcbc661cf1aa72b78c_RGBA_0_Vector4, _Property_0e63c2d5c5e049dbbd1bdb87dfff74ba_Out_0_Vector4, _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4);
            float4 _Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4;
            Unity_Branch_float4(_Property_0f30bcb3db7546c9858ee2561fd886af_Out_0_Boolean, _Multiply_e76756538e9f49a8b737e461d4ea8c5f_Out_2_Vector4, float4(0, 0, 0, 0), _Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4);
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.BaseColor = (_Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4.xyz);
            surface.Emission = (_Branch_6dd5a87d1c9e43619716edc6d1cdae17_Out_3_Vector4.xyz);
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.tex, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.samplerstate, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_R_4_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.r;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_G_5_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.g;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_B_6_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.b;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_A_7_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.a;
            float4 _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4, _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4, _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4);
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.BaseColor = (_Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4.xyz);
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Normal_TexelSize;
        float4 _ORM_TexelSize;
        float _AOIntensity;
        float _MetallicAmount;
        float _Smoothness_Intensity;
        float _N_Intensity;
        float4 _Emmission_TexelSize;
        float4 _E_Intensity;
        float _Emmit;
        float4 _Alpha_TexelSize;
        float _A_Clip;
        float4 _BaseColor;
        float _Opacity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_ORM);
        SAMPLER(sampler_ORM);
        TEXTURE2D(_Emmission);
        SAMPLER(sampler_Emmission);
        TEXTURE2D(_Alpha);
        SAMPLER(sampler_Alpha);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.tex, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.samplerstate, _Property_b638d51a43b447858276e2e9c1f102db_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_R_4_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.r;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_G_5_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.g;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_B_6_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.b;
            float _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_A_7_Float = _SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4.a;
            float4 _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_5b5b610ede0945f29857fb1dfaecada6_RGBA_0_Vector4, _Property_0dd6bcc0a46349c9ac9d0fb95239026d_Out_0_Vector4, _Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4);
            UnityTexture2D _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Alpha);
            float4 _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.tex, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.samplerstate, _Property_bcce304c531e46b1ae2a876ea6391f13_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_R_4_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.r;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_G_5_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.g;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_B_6_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.b;
            float _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_A_7_Float = _SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4.a;
            float _Property_f653d4962f704161b4723510963500b9_Out_0_Float = _Opacity;
            float4 _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_23164dcc3fad4fa084175e52ae2c09b6_RGBA_0_Vector4, (_Property_f653d4962f704161b4723510963500b9_Out_0_Float.xxxx), _Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4);
            float _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float = _A_Clip;
            surface.BaseColor = (_Multiply_2d9c0ee86f4c404eb6d9eed8ebfa8f63_Out_2_Vector4.xyz);
            surface.Alpha = (_Multiply_eb61c2b1cacb401ebd100421e40e5e07_Out_2_Vector4).x;
            surface.AlphaClipThreshold = _Property_9eaa4acf53944b59a8f77d5e20a2d744_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}