Shader "Custom/ScreenOverlay"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BlendTex("Blend Texture",2d ) = "white"{}
        _Opacity("Blend Opacity",Range(0,1)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform sampler2D _BlendTex;
            fixed _Opacity;

            fixed OverlayBlendMode(fixed basePixel,fixed blendPixel)
            {
                if (basePixel < 0.5)
                {
                    return (2.0 * basePixel * blendPixel);
                }
                else
                {
                    return (1.0 - 2.0 * (1.0 - basePixel) * (1.0 - blendPixel));
                }
            }

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 blendTex = tex2D(_BlendTex, i.uv);
                fixed4 blendImage = renderTex;
                blendImage.r = OverlayBlendMode(renderTex.r, blendTex.r);
                blendImage.g = OverlayBlendMode(renderTex.g, blendTex.g);
                blendImage.b = OverlayBlendMode(renderTex.b, blendTex.b);
                renderTex = lerp(renderTex, blendImage, _Opacity);

                return  renderTex;
            }
            ENDCG
        }
    }
    FallBack Off
}