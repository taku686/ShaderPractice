Shader "Unlit/Lava"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Header(Ambient)]
        _Ambient("Intensity",range(0,1)) = 0.1
        _AmbColor("Color",color) = (1,1,1,1)
        [Header(Diffuse)]
        _Diffuse("Value",range(0,1)) = 1
        _DiffColor("Color",color) = (1,1,1,1)
        [Header(Specular)]
        _Shininess("Shininess",range(0.1,10)) = 2
        _SpecColor("Color",color) = (1,1,1,1)

        [Header(Emission)]
        _EmissionTex("Emission Tex",2d) = "white"{}
        _EmiVal("Intensity",float) = 0
        [HDR]
        _EmiColor("Color",color) = (1,1,1,1)
        [Header(Normal)]
        _NormalTex("Normal Tex",2d) = "white"{}
        [Header(Speed)]
        _SpeedX("Speed X",float ) = 0
        _SpeedY("Speed Y",float ) = 0
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

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _EmissionTex;
            sampler2D _NormalTex;
            float _Ambient;
            fixed4 _AmbColor;
            float _Diffuse;
            fixed4 _DiffColor;
            float _Shininess;
            fixed4 _SpecColor;
            float _EmiVal;
            float4 _EmiColor;
            fixed4 _LightColor0;
            float _SpeedX;
            float _SpeedY;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                //  float3 worldNormal : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float3 tangent : TEXCOORD4;
                float3 binormal : TEXCOORD5;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                // o.worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = normalize(mul(unity_ObjectToWorld, v.tangent)).xyz; //接線をワールド座標系に変換
                o.binormal = cross(v.normal, v.tangent) * v.tangent.w; //変換前の法線と接線から従法線を計算
                o.binormal = normalize(mul(unity_ObjectToWorld, o.binormal)); //従法線をワールド座標系に変換
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 speed = float2(_SpeedX * _Time.y, _SpeedY * _Time.y);
                float2 uv = i.uv + speed;
                half3 normalmap = UnpackNormal(tex2D(_NormalTex, uv));
                float3 normal = (i.tangent * normalmap.x) + (i.binormal * normalmap.y) + (i.normal * normalmap.z);
                fixed4 col = tex2D(_MainTex, uv);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = UnityObjectToViewPos(i.worldPos);
                // float3 worldNormal = normalize(i.worldNormal);

                fixed4 amb = _Ambient * _AmbColor;

                float NdotL = max(0, dot(normal, lightDir));
                fixed4 diff = _Diffuse * _DiffColor * NdotL * _LightColor0;
                fixed4 light = amb + diff;

                float3 refl = normalize(reflect(-lightDir, normal));
                float RdotV = max(0, dot(refl, viewDir));
                fixed4 spec = pow(RdotV, _Shininess) * _SpecColor * _LightColor0 * NdotL;

                light += spec;

                col.rgb *= light.rgb;
                fixed4 emi = tex2D(_EmissionTex, uv) * _EmiColor * _EmiVal;
                col.rgb += emi.rgb;
                return col;
            }
            ENDCG
        }
    }
}