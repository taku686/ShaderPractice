Shader "Unlit/BasicLightingPerVertex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        [Header(Ambient)]
        _Ambient("Intensity",range(0,1)) = 0.1
        _AmbColor("Color",Color) = (1,1,1,1)
        [Header(Diffuse)]
        _Diffuse("Val",range(0,1)) = 1
        _DiffColor("Color",color ) = (1,1,1,1)
        [Header(Specular)]
        [Toggle] _Spec("Enabled?",float ) = 0
        _Shininess("Shininess",range(0.1,10)) = 1
        _SpecColor("Specular Color",color) = (1,1,1,1)
        [Header(Emission)]
        _EmissionTex("Emission Tex",2d) = "white"{}
        _EmiVal("Intensity",float ) = 0
        [HDR]
        _EmiColor("Color",color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue" = "Geometry"
            "LightMode" = "ForwardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature __ _SPEC_ON

            #include "UnityCG.cginc"

            fixed4 _LightColor0;

            float _Ambient;
            fixed4 _AmbColor;

            fixed4 _Diffuse;
            fixed4 _DiffColor;

            float _Shininess;
            fixed4 _SpecColor;

            sampler2D _MainTex;
            sampler2D _EmissionTex;
            float _EmiVal;
            float4 _EmiColor;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float uv : TEXCOORD0;
                fixed4 light : COLOR0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = mul(unity_MatrixMVP, v.vertex);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldNormal.xyz);

                fixed4 amb = _Ambient * _AmbColor;

                float NdotL = max(0, dot(worldNormal, lightDir));
                fixed4 dif = NdotL * _DiffColor * _LightColor0 * _Diffuse;

                o.light = amb + dif;

                #if _SPEC_ON
float3 refl = reflect(-lightDir, worldNormal);
                float RdotV = max(0, dot(refl, viewDir));
                fixed4 spec = pow(RdotV, _Shininess) * _LightColor0 * NdotL * _SpecColor;
                o.light += spec;
                #endif

                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                c.rgb *= i.light;

                fixed4 emi = tex2D(_EmissionTex, i.uv).r * _EmiColor * _EmiVal;
                c.rgb += emi.rgb;

                return c;
            }
            ENDCG
        }
    }
}