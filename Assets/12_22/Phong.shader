Shader "Custom/Phong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor("Supecular Color",Color) = (1,1,1,1)
        _SpecPower("Specular Power",Range(0,30)) = 10
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
        #pragma surface surf Phong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;
        fixed4 _SpecularColor;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
        }

        fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, float3 viewDir, float atten)
        {
            float NdotL = max(0, dot(s.Normal, lightDir));
            float3 halfVector = normalize(lightDir + viewDir);
            float NdotH = max(0, dot(s.Normal, halfVector));
            float spec = pow(NdotH, _SpecPower) * _SpecularColor;
            float4 color;
            color.rgb = (s.Albedo * NdotL * _LightColor0.rgb) + (spec * _SpecularColor.rgb * atten * _LightColor0.rgb);
            color.a = s.Alpha;
            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}