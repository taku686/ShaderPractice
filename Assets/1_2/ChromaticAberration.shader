Shader "Unlit/ChromaticAberration"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Header(Red)]
        _RedX("offset X",range(-0.5,0.5)) = 0
        _RedY("offset Y",range(-0.5,0.5)) = 0
        [Header(Green)]
        _BlueX("offset X",range(-0.5,0.5)) = 0
        _BlueY("offset Y",range(-0.5,0.5)) = 0
        [Header(Blue)]
        _GreenX("offset X",range(-0.5,0.5)) = 0
        _GreenY("offset Y",range(-0.5,0.5)) = 0
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
            #pragma vertex vert_img;
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _RedX;
            float _RedY;
            float _BlueX;
            float _BlueY;
            float _GreenX;
            float _GreenY;

            fixed4 frag(v2f_img i) : SV_Target
            {
                fixed4 col = fixed4(1, 1, 1, 1);
                float2 red_uv = i.uv + float2(_RedX, _RedY);
                float2 green_uv = i.uv + float2(_GreenX, _GreenY);
                float2 blue_uv = i.uv + float2(_BlueX, _BlueY);

                col.r = tex2D(_MainTex, red_uv).r;
                col.g = tex2D(_MainTex, green_uv).g;
                col.b = tex2D(_MainTex, blue_uv).b;

                return col;
            }
            ENDCG
        }
    }
}