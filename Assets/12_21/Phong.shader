Shader "Custom/Phong"
{
    Properties
    {
        _MainTint ("Main Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor("Specular Power",Color) = (1,1,1,1)
        _SpecPower("Specular Power",Range(0,30)) = 1
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
        #pragma surface surf CustomBlinnPhong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _MainTint;
        fixed4 _SpecularColor;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        fixed4 LightingCustomBlinnPhong(SurfaceOutput s,fixed3 lightDir, half3 viewDir,fixed atten)
        {
            float NdotL = max(0, dot(s.Normal, lightDir));
            float3 halfVector = normalize(lightDir + viewDir);
            float NdotH = max(0, dot(s.Normal, halfVector));
            float spec = pow(NdotH, _SpecPower) * _SpecColor;
            float4 color;
            color.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec) * atten;
            color.a = s.Alpha;
            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}