Shader "UI/Blur"
{
    Properties
    {
        _MaskTex("Mask Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _Range("Range", Range (0, 1)) = 0

        _ColorMask ("Color Mask", Float) = 15
    }

    SubShader
    {
        Tags
        {
            "Queue"="AlphaTest"
            "IgnoreProjector"="True"
            "RenderType"="TransparentCutout"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"


            struct appdata_t
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                half2 texcoord : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            fixed4 _Color;
            fixed4 _TextureSampleAdd;

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

                OUT.texcoord = IN.texcoord;

                #ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
                #endif

                OUT.color = IN.color * _Color;
                return OUT;
            }

            sampler2D _MainTex;
            sampler2D _MaskTex;
            float _Range;

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = _Color;
                color += tex2D(_MainTex, IN.texcoord) * 0.5f;
                color += tex2D(_MainTex, IN.texcoord + float2(0.008, 0.008)) * _Range;
                color += tex2D(_MainTex, IN.texcoord + float2(0.008, -0.008)) * _Range;
                color += tex2D(_MainTex, IN.texcoord + float2(-0.008, -0.008)) * _Range;
                color += tex2D(_MainTex, IN.texcoord + float2(-0.008, 0.008)) * _Range;
                color *= IN.color;

                return color;
            }
            ENDCG
        }
    }
}