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
        #pragma surface surf Phong

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

        fixed4 LightingPhong(SurfaceOutput s,fixed3 lightDir, half3 viewDir,fixed atten)
        {
            float NdotL = dot(s.Normal, lightDir);
            float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
            float spec = pow(max(0, dot(viewDir, reflectionVector)), _SpecPower);
            float3 finalSpec = _SpecularColor.rgb * spec;
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * max(0, NdotL) * atten) + (_LightColor0 * finalSpec * atten);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}