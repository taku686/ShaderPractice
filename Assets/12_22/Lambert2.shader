Shader "Custom/Lambert"
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
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        fixed4 LightingLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            float NdotL = dot(s.Normal, lightDir);
            fixed4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;
            col.a = s.Alpha;
            return col;
        }
        ENDCG
    }
    FallBack "Diffuse"
}