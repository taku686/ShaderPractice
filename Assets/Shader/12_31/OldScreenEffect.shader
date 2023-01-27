Shader "Unlit/OldScreenEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VignetteTex("Vignette Texture",2D) = "white"{}
        _ScratchesTex("Scratches Texture",2D) = "white"{}
        _DustTex("Dust Texture",2D) = "white"{}
        _SepiaColor("Sepia Color",Color) = (1,1,1,1)
        _EffectAmount("Old Film Effect Amount",Range(0,1)) = 1.0
        _VignetteAmount("Vignette Opacity",Range(0,1)) = 1.0
        _ScratchesYSpeed("Scratches Y Speed",float) = 10.0
        _ScratchesXSpeed("Scratches X Speed",float) = 10.0
        _dustYSpeed("Dust Y Speed",float) = 10.0
        _dustXSpeed("Dust X Speed",float) = 10.0
        _RandomValue("Random Value",float) = 1.0
        _Contrast("Contrast",float) = 3.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform sampler2D _VignetteTex;
            uniform sampler2D _ScratchesTex;
            uniform sampler2D _DustTex;
            fixed4 _SepiaColor;
            fixed _EffectAmount;
            fixed _VignetteAmount;
            fixed _ScratchesYSpeed;
            fixed _ScratchesXSpeed;
            fixed _dustYSpeed;
            fixed _dustXSpeed;
            fixed _RandomValue;
            fixed _Contrast;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);
                half2 scratchesUV = half2(
                    i.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed), i.uv.y + (_Time.x * _ScratchesYSpeed));
                fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);
                half2 dustUV = half2(i.uv.x + (_RandomValue * (_SinTime.z * _dustXSpeed)),
                                     i.uv.y + (_RandomValue) * (_SinTime.z * _dustYSpeed));
                fixed4 dustTex = tex2D(_DustTex, dustUV);
                fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb);
                fixed4 finalColor = lum + lerp(_SepiaColor, _SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 0.1f), _RandomValue);
                finalColor = pow(finalColor, _Contrast);
                fixed3 contrastWhite = fixed3(1, 1, 1);
                finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
                finalColor.rgb *= lerp(scratchesTex, contrastWhite, _RandomValue);
                finalColor.rgb *= lerp(dustTex, contrastWhite, _RandomValue * _SinTime.z);
                finalColor = lerp(renderTex, finalColor, _EffectAmount);
                return finalColor;
            }
            ENDCG
        }
    }
}