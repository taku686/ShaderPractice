Shader "Unlit/BasicLightingPerFragment"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Header(Ambient)]
        _Ambient("Intensity",range(0,1)) = 0.1
        _AmbColor("Color",Color) = (1,1,1,1)

        [Header(Diffuse)]
        _Diffuse("Val",range(0,1)) = 1
        _DiffColor("Color",color) = (1,1,1,1)

        [Header(Specular)]
        [Toggle]_Spec("Enabled?",float)= 0
        _Shininess("Shininess",range(0.1,10)) = 2
        _SpecColor("Color",color) = (1,1,1,1)

        [Header(Emission)]
        _EmissionTex("Emission Tex",2d) = "white"{}
        _EmiVal("Intensity",float) = 0
        [HDR]_EmiColor("Color",color) = (1,1,1,1)
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

            sampler2D _MainTex;
            sampler2D _EmissionTex;
            float _Ambient;
            fixed4 _AmbColor;
            float _Diffuse;
            fixed4 _DiffColor;
            float _Shininess;
            fixed4 _SpecColor;
            float _EmiVal;
            float4 _EmiColor;
            fixed4 _LightColor0;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOOR0;
                float3 worldNormal : TEXCOOR1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                float3 worldNormal = normalize(i.worldNormal);

                fixed4 amb = _Ambient * _AmbColor;

                float NdotL = max(0, dot(worldNormal, lightDir));
                fixed4 diff = _Diffuse * _DiffColor * _LightColor0 * NdotL;

                fixed4 light = amb + diff;


                #if _SPEC_ON
                float3 refl = normalize(reflect(-lightDir, worldNormal));
                float RdotV = max(0, dot(refl, viewDir));
                fixed4 spec = pow(RdotV, _Shininess) * _SpecColor * _LightColor0 *NdotL;

                light += spec;
                #endif

                col.rgb *= light.rgb;

                fixed4 emi = tex2D(_EmissionTex, i.uv) * _EmiColor * _EmiVal;
                col.rgb += emi.rgb;
                return col;
            }
            ENDCG
        }
    }
}