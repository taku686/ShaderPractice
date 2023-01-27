Shader "Unlit/SimpleLambert2"
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
        LOD 100


        CGPROGRAM
        #pragma surface surf SimpleLambert
        #pragma target 3.0
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            
            o.Albedo = tex2D(_MainTex,IN.uv_MainTex);
        }

        half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = max(0, dot(s.Normal, lightDir));
            half4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * NdotL;
            col.a = s.Alpha;
            return col;
        }
        ENDCG
    }
    FallBack "Diffuse"
}