Shader "Custom/NormalShader"
{
    Properties
    {
        _MainTint("Diffuse Tint",Color) = (0,1,0,1)
        _NormalTex("Normal Map",2D) = "bump" {}
        _NormalMapIntensity("Normal intensity",Range(0,3)) = 1
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
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        float4 _MainTint;
        sampler2D _NormalTex;
        float _NormalMapIntensity;

        struct Input
        {
            float2 uv_NormalTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _MainTint;
            float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            normalMap.x *= _NormalMapIntensity;
            normalMap.y *= _NormalMapIntensity;
            o.Normal = normalize(normalMap.rgb);
        }
        ENDCG
    }
    FallBack "Diffuse"
}