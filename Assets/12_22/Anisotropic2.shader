Shader "Custom/Anisotropic2"
{
    Properties
    {
        _MainTint ("Main Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor("Specular Color",Color) = (1,1,1,1)
        _Specular("Specular Amount",Range(0,1))= 0.5
        _SpecPower("Specular Power",Range(0,1)) = 0.5
        _AnisoDir("Anisotropic Direction",2D) = ""{}
        _AnisoOffset("Anisotropic Offset",Range(-1,1)) = -0.2
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
        #pragma surface surf Anisotropic

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _AnisoDir;
        float4 _MainTint;
        float4 _SpecularColor;
        float _AnisoOffset;
        float _Specular;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AnisoDir;
        };

        struct SurfaceAnisoOutput
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 AnisoDirection;
            half Specular;
            fixed Gloss;
            fixed Alpha;
        };

        void surf(Input IN, inout SurfaceAnisoOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));
            o.AnisoDirection = anisoTex;
            o.Specular = _Specular;
            o.Gloss = _SpecPower;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        fixed4 LightingAnisotropic(SurfaceAnisoOutput s, half3 viewDir, half3 lightDir, float atten)
        {
            fixed3 halfVector = normalize(normalize(viewDir) + normalize(lightDir));
            float NdotL = saturate(dot(lightDir, s.Normal));
            fixed3 H = normalize(s.Normal + s.AnisoDirection);
            fixed HdotA = dot(H, halfVector);
            float aniso = max(0, sin(radians(HdotA + _AnisoOffset) * 180));
            float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);
            fixed3 albedoColor = s.Albedo * _LightColor0.rgb * NdotL;
            fixed3 specColor = _LightColor0.rgb * _SpecularColor.rgb * spec;
            fixed4 c;
            c.rgb = (albedoColor + specColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}