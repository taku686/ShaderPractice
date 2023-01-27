Shader "Unlit/SampleLambert3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf SampleLambert
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = fixed4(1, 1, 1, 1);
        }

        half4 LightingSampleLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = max(0, dot(s.Normal, lightDir));
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * NdotL + fixed4(0.2f, 0.2f, 0.2f, 1);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}