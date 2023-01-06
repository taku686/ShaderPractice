Shader "Custom/MobileShader"
{
    Properties
    {
        _Diffuse("Diffuse",2D) = "white"{}
        _SpecIntensity("Specular Width",Range(0.01,1)) = 0.5
        _NormalMap("Nornal Map",2D) = "bump"{}
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
        #pragma surface surf MobileBlinnPhong exclude_path:prepass nolihghtmap noforwardadd halfasview


        sampler2D _Diffuse;
        sampler2D _NormalMap;
        fixed _SpecIntensity;

        struct Input
        {
            float2 uv_Diffuse;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 diffuseTex = tex2D(_Diffuse, IN.uv_Diffuse);
            o.Albedo = diffuseTex.rgb;
            o.Gloss = diffuseTex.a;
            o.Alpha = 0.0;
            o.Specular = _SpecIntensity;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_Diffuse));
        }

        inline fixed4 LightingMobileBlinnPhong(SurfaceOutput s,fixed3 lightDir,fixed3 halfDir,fixed atten)
        {
            fixed diff = max(0, dot(s.Normal, lightDir));
            fixed4 nh = max(0, dot(s.Normal, halfDir));
            fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff * _LightColor0.rgb * spec) * (atten * 2);
            c.a = 0;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}