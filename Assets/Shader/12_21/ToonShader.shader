Shader "Custom/SimpleLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp", 2D) = "white"{}
        _CelShadingLevels("CelShadingLevels",Range(0,10)) = 2
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Toon
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;
        float _CelShadingLevels;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

        half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);
            // NdotL = tex2D(_RampTex,fixed2(NdotL, 0.5));
            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * (cel * atten);
            color.a = s.Alpha;
            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}