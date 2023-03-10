Shader "Unlit/Extrude"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Factor("Factor",Range(0,2)) = 0.2
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #include "UnityCG.cginc"

            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct g2f
            {
                float4 pos: SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 col : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Factor;

            v2g vert(appdata_base v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal = v.normal;
                return o;
            }

            [maxvertexcount(24)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;
                float3 edgeA = IN[1].vertex - IN[0].vertex;
                float3 edgeB = IN[2].vertex - IN[0].vertex;
                float3 normalFace = normalize(cross(edgeA, edgeB));

                for (int i = 0; i < 3; i++)
                {
                    o.pos = UnityObjectToClipPos(IN[i].vertex);
                    o.uv = IN[i].uv;
                    o.col = fixed4(0., 0., 0., 1.);
                    triStream.Append(o);

                    o.pos = UnityObjectToClipPos(IN[i].vertex + float4(normalFace, 0) * _Factor);
                    o.uv = IN[i].uv;
                    o.col = fixed4(1., 1., 1., 1.);
                    triStream.Append(o);

                    int inext = (i + 1) % 3;

                    o.pos = UnityObjectToClipPos(IN[inext].vertex);
                    o.uv = IN[inext].uv;
                    o.col = fixed4(0., 0., 0., 1.);
                    triStream.Append(o);

                    triStream.RestartStrip();

                    o.pos = UnityObjectToClipPos(IN[i].vertex + float4(normalFace, 0) * _Factor);
                    o.uv = IN[i].uv;
                    o.col = fixed4(1., 1., 1., 1.);
                    triStream.Append(o);

                    o.pos = UnityObjectToClipPos(IN[inext].vertex);
                    o.uv = IN[inext].uv;
                    o.col = fixed4(0., 0., 0., 1.);
                    triStream.Append(o);

                    o.pos = UnityObjectToClipPos(IN[inext].vertex + float4(normalFace, 0) * _Factor);
                    o.uv = IN[inext].uv;
                    o.col = fixed4(1., 1., 1., 1.);
                    triStream.Append(o);

                    triStream.RestartStrip();
                }

                for (int i = 0; i < 3; i++)
                {
                    o.pos = UnityObjectToClipPos(IN[i].vertex + float4(normalFace, 0) * _Factor);
                    o.uv = IN[i].uv;
                    o.col = fixed4(1., 1., 1., 1.);
                    triStream.Append(o);
                }

                triStream.RestartStrip();

                for (int i = 0; i < 3; i++)
                {
                    o.pos = UnityObjectToClipPos(IN[i].vertex);
                    o.uv = IN[i].uv;
                    o.col = fixed4(0., 0., 0., 1.);
                    triStream.Append(o);
                }

                triStream.RestartStrip();
            }

            fixed4 frag(g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * i.col;
                return col;
            }
            ENDCG
        }
    }
}