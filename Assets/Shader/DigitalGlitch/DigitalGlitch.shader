Shader "Unlit/DigitalGlitch"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "" {}
        _NoiseTex ("Noise Texture", 2D) = "" {}
        _TrashTex ("Trash Texture", 2D) = "" {}
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
            #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            sampler2D _TrashTex;
            float _Intensity;

            float4 frag(v2f_img i) : SV_Target
            {
                float4 glitch = tex2D(_NoiseTex, i.uv);

                float thresh = 1.001 - _Intensity * 1.001;
                float w_d = step(thresh, pow(glitch.z, 2.5)); // displacement glitch
                float w_f = step(thresh, pow(glitch.w, 2.5)); // frame glitch
                float w_c = step(thresh, pow(glitch.z, 3.5)); // color glitch

                // Displacement.
                float2 uv = frac(i.uv + glitch.xy * w_d);
                float4 source = tex2D(_MainTex, uv);

                // Mix with trash frame.
                float3 color = lerp(source, tex2D(_TrashTex, uv), w_f).rgb;

                // Shuffle color components.
                float3 neg = saturate(color.grb + (1 - dot(color, 1)) * 0.5);
                color = lerp(color, neg, w_c);

                return float4(color, source.a);
            }
            ENDCG
        }
    }
}