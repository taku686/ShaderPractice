Shader "Custom/Toon2"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp",2D) = "white"{}
        _CelShadingLevels("Shaing Levels",Range(0,10)) = 2
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Toon

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;
        float _CelShadingLevels;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_RampTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }

        fixed4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)
        {
            float NdotL = max(0, dot(s.Normal, lightDir));
            half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);
            fixed4 col;
            col.rgb = s.Albedo * cel * _LightColor0 * atten;
            col.a = s.Alpha;
            return col;
        }
        ENDCG
    }
    FallBack "Diffuse"
}