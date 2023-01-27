Shader "Custom/SamplePhong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
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
        #pragma surface surf  SimplePhong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }

        half4 LightingSimplePhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half NdotL = max(0, dot(s.Normal, lightDir));
            float3 R = normalize(lightDir + 2.0 * s.Normal * NdotL);
            float3 spec = pow(max(0, dot(R, viewDir)), 30);

            half4 c;
            
            c.rgb = s.Albedo * _LightColor0 * NdotL + spec;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}