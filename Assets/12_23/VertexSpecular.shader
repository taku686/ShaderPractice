// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/VertexSpecular"
{
    Properties
    {
        [Header(Diffuse)]
        _Color("Color",Color) = (1,1,1,1)
        _Diffuse("Value",Range(0,1)) = 1
        [Header(Specular)]
        _SpecColor("Color",Color) = (1,1,1,1)
        _Shininess("Shininess",Range(0.1,10)) = 1

    }
    SubShader
    {
        Tags
        {
            "LightMode"="ForwardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                fixed4 col : COLOR0;
                float4 pos : SV_POSITION;
            };

            fixed4 _LightColor0;

            fixed4 _Color;
            fixed4 _SpecColor;

            float _Diffuse;
            float _Shininess;


            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                float3 worldPos = mul(unity_WorldToObject, v.vertex);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);
                float3 refl = reflect(-lightDir, worldNormal);

                float NdotL = max(0, dot(lightDir, worldNormal));
                float RdotV = max(0, dot(refl, viewDir));

                fixed4 diff = _Color * NdotL * _LightColor0 * _Diffuse;
                fixed4 spec = ceil(NdotL) * _LightColor0 * _SpecColor * pow(RdotV, _Shininess);

                o.col = diff + spec;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.col;
            }
            ENDCG
        }
    }
}