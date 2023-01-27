Shader "Unlit/Wireframe"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [PowerSlider(3.0)]
        _WireframeVal("Wireframe Value",range(0,1)) = 0.05
        _FrontColor("Front Color",Color) = (1,1,1,1)
        _BackColor("Back Color",Color) = (1,1,1,1)
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
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #include "UnityCG.cginc"

            float4 _MainTex_ST;
            sampler2D _MainTex;
            float _WireframeVal;
            fixed4 _FrontColor;
            fixed4 _BackColor;


            struct v2g
            {
                float4 pos : POISTION;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float3 bary : TEXCOORD0;
            };

            v2g vert(appdata_base v)
            {
                v2g o;
                o.pos = mul(unity_MatrixMVP, v.vertex);
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;
                o.pos = IN[0].pos;
                o.bary = float3(1, 0, 0);
                triStream.Append(o);
                o.pos = IN[1].pos;
                o.bary = float3(0, 0, 1);
                triStream.Append(o);
                o.pos = IN[2].pos;
                o.bary = float3(0, 1, 0);
                triStream.Append(o);
            }

            fixed4 frag(g2f i) : SV_Target
            {
                if (!any(bool3(i.bary.x < _WireframeVal, i.bary.y < _WireframeVal, i.bary.z < _WireframeVal)))
                    discard;

                return _BackColor;
            }
            ENDCG
        } Pass
        {
            Cull Back
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #include "UnityCG.cginc"

            float4 _MainTex_ST;
            sampler2D _MainTex;
            float _WireframeVal;
            fixed4 _FrontColor;
            fixed4 _BackColor;


            struct v2g
            {
                float4 pos : POISTION;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float3 bary : TEXCOORD0;
            };

            v2g vert(appdata_base v)
            {
                v2g o;
                o.pos = mul(unity_MatrixMVP, v.vertex);
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;
                o.pos = IN[0].pos;
                o.bary = float3(1, 0, 0);
                triStream.Append(o);
                o.pos = IN[1].pos;
                o.bary = float3(0, 0, 1);
                triStream.Append(o);
                o.pos = IN[2].pos;
                o.bary = float3(0, 1, 0);
                triStream.Append(o);
            }

            fixed4 frag(g2f i) : SV_Target
            {
                if (!any(bool3(i.bary.x < _WireframeVal, i.bary.y < _WireframeVal, i.bary.z < _WireframeVal)))
                    discard;

                return _FrontColor;
            }
            ENDCG
        }
    }
}