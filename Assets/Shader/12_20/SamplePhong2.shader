Shader "Custom/SamplePhong2"
{
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf SamplePhong
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = fixed4(1, 1, 1, 1);
        }

        half4 LightingSamplePhong(SurfaceOutput s, half3 lightDir, half3 viewDir)
        {
            half NdotL = max(0, dot(s.Normal, lightDir));
            float3 R = normalize(-lightDir + 2.0 * s.Normal * NdotL);
            float3 spec = pow(max(0, dot(R, viewDir)), 10);

            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * NdotL + spec + fixed4(0.1f, 0.1f, 0.1f, 1);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}