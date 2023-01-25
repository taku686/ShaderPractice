Shader "Custom/SnowShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump("Bump",2D) = "bump"{}
        _Snow("Level of Snow",Range(-1.0,1.0)) = 0.5
        _SnowColor("Color of Snow",Color) = (1,1,1,1)
        _SnowDirection("Direction of Snow",Vector) = (0,1,0)
        _SnowDepth("Depth of snow",Range(0,1)) = 0
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
        #pragma surface surf Standard vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Bump;
        float _Snow;
        float4 _SnowColor;
        float4 _SnowDirection;
        float4 _Color;
        float _SnowDepth;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Bump;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void vert(inout appdata_full v)
        {
            float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);
            if (dot(v.normal, sn.xyz) >= _Snow)
            {
                v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
            }
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection) >= _Snow)
            {
                o.Albedo = _SnowColor.rgb;
            }
            else
            {
                o.Albedo = c.rgb * _SnowColor;
            }
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}