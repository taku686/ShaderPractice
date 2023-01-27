Shader "Unlit/WireframeWithoutDiagonal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [PowerSlider(3.0)]
        _WireframeVal("Wireframe Value",range(0,1)) = 0.05
        _FrontColor("Front Color",Color) = (1,1,1,1)
        _BackColor("Back Color",Color) = (1,1,1,1)
        [Toggle]
        _RemoveDiag("Remove Diagonal?",float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            ZWrite ON
            ColorMask 0
        }
        Pass
        {
            Cull Back
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #pragma shader_feature __ _REMOVEDIAG_ON

            #include <UnityLightingCommon.cginc>

            #include "UnityCG.cginc"

            float4 _MainTex_ST;
            sampler2D _MainTex;
            float _WireframeVal;
            fixed4 _FrontColor;
            fixed4 _BackColor;


            struct v2g
            {
                float4 worldPos : POISTION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float3 bary : TEXCOORD1;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            v2g vert(appdata_base v)
            {
                v2g o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.texcoord;
                o.normal = v.normal;
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                float3 param = float3(0., 0., 0.);

                #if _REMOVEDIAG_ON
                float EdgeA = length(IN[0].worldPos - IN[1].worldPos);
                float EdgeB = length(IN[1].worldPos - IN[2].worldPos);
                float EdgeC = length(IN[2].worldPos - IN[0].worldPos);
               
                if(EdgeA > EdgeB && EdgeA > EdgeC)
                    param.y = 1.;
                else if (EdgeB > EdgeC && EdgeB > EdgeA)
                    param.x = 1.;
                else
                    param.z = 1.;
                #endif

                g2f o;
                o.pos = mul(UNITY_MATRIX_VP, IN[0].worldPos);
                o.bary = float3(1., 0., 0.) + param;
                o.uv = IN[0].uv;
                o.normal = IN[0].normal;
                triStream.Append(o);
                o.pos = mul(UNITY_MATRIX_VP, IN[1].worldPos);
                o.bary = float3(0., 0., 1.) + param;
                o.uv = IN[1].uv;
                o.normal = IN[1].normal;
                triStream.Append(o);
                o.pos = mul(UNITY_MATRIX_VP, IN[2].worldPos);
                o.bary = float3(0., 1., 0.) + param;
                o.uv = IN[2].uv;
                o.normal = IN[2].normal;
                triStream.Append(o);
            }

            fixed3 diffuseLambert(float3 normal)
            {
                float diffuse = max(0, dot(normalize(normal), _WorldSpaceLightPos0.xyz));
                return _LightColor0.rgb * diffuse;
            }


            fixed4 frag(g2f i) : SV_Target
            {
                if (!any(bool3(i.bary.x < _WireframeVal, i.bary.y < _WireframeVal, i.bary.z < _WireframeVal)))
                    discard;
                fixed4 col;
                col = _BackColor * tex2D(_MainTex, i.uv);
                col.rgb *= diffuseLambert(i.normal) * _LightColor0.rgb;
                return col;
            }
            ENDCG
        }
        Pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #pragma shader_feature __ _REMOVEDIAG_ON

            #include <UnityLightingCommon.cginc>

            #include "UnityCG.cginc"

            float4 _MainTex_ST;
            sampler2D _MainTex;
            float _WireframeVal;
            fixed4 _FrontColor;
            fixed4 _BackColor;


            struct v2g
            {
                float4 worldPos : POISTION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float3 bary : TEXCOORD1;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            v2g vert(appdata_base v)
            {
                v2g o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.texcoord;
                o.normal = v.normal;
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                float3 param = float3(0., 0., 0.);

                #if _REMOVEDIAG_ON
                float EdgeA = length(IN[0].worldPos - IN[1].worldPos);
                float EdgeB = length(IN[1].worldPos - IN[2].worldPos);
                float EdgeC = length(IN[2].worldPos - IN[0].worldPos);
               
                if(EdgeA > EdgeB && EdgeA > EdgeC)
                    param.y = 1.;
                else if (EdgeB > EdgeC && EdgeB > EdgeA)
                    param.x = 1.;
                else
                    param.z = 1.;
                #endif

                g2f o;
                o.pos = mul(UNITY_MATRIX_VP, IN[0].worldPos);
                o.bary = float3(1., 0., 0.) + param;
                o.uv = IN[0].uv;
                o.normal = IN[0].normal;
                triStream.Append(o);
                o.pos = mul(UNITY_MATRIX_VP, IN[1].worldPos);
                o.bary = float3(0., 0., 1.) + param;
                o.uv = IN[1].uv;
                o.normal = IN[1].normal;
                triStream.Append(o);
                o.pos = mul(UNITY_MATRIX_VP, IN[2].worldPos);
                o.bary = float3(0., 1., 0.) + param;
                o.uv = IN[2].uv;
                o.normal = IN[2].normal;
                triStream.Append(o);
            }

            fixed3 diffuseLambert(float3 normal)
            {
                float diffuse = max(0, dot(normalize(normal), _WorldSpaceLightPos0.xyz));
                return _LightColor0.rgb * diffuse;
            }

            fixed4 frag(g2f i) : SV_Target
            {
                if (!any(bool3(i.bary.x < _WireframeVal, i.bary.y < _WireframeVal, i.bary.z < _WireframeVal)))
                    discard;
                fixed4 col;
                col = _FrontColor * tex2D(_MainTex, i.uv);
                col.rgb *= diffuseLambert(i.normal);
                return col;
            }
            ENDCG
        }
    }
}