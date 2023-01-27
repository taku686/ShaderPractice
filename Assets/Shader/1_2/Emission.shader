Shader "Unlit/Emission"
{
    Properties
    {
        [Header(Diffuse)]
        _Color("Color",Color) = (1,1,1,1)
        _Diffuse("Diffuse",Range(0,1)) = 1
        [Header(Emission)]
        _MainTex("Emission Tex",2D) = "white"{}
        [HDR]
        _EmissionColor("Emission Color",Color) = (1,1,1,1)
        _Threshold("Threshold",range(0,1)) = 1
    }
    SubShader
    {
        Tags
        {
            "LightMode" = "ForwardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Diffuse;
            float4 _EmissionColor;
            float _Threshold;
            fixed4 _LightColor0;

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed4 color : COLOR0;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul(unity_MatrixMVP, v.vertex);
                float3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(0, dot(lightDir, worldNormal));
                fixed4 diff = _Color * NdotL * _LightColor0 * _Diffuse;
                o.color = diff;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 emi = tex2D(_MainTex, i.uv).r * _EmissionColor.rgb * _Threshold;
                i.color.rgb += emi;
                return i.color;
            }
            ENDCG
        }
    }
}