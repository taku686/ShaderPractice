Shader "Custom/Section"
{

    Properties
    {
        _MainTex("Main Tex",2d) = "white"{}
        _Color1 ("Outside color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Color2 ("Section color", Color) = (1.0, 1.0, 1.0, 1.0)
        _EdgeWidth ("Edge width", Range(0.9, 0.1)) = 0.9
        _Val ("Height value", float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Geometry"
        }

        //  PASS 1
        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        struct Input
        {
            float3 worldPos;
        };

        fixed4 _Color1;
        float _Val;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            if (IN.worldPos.y > _Val)
                discard;
            o.Albedo = _Color1;
        }
        ENDCG

        //  PASS 2
        Pass
        {

            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 _Color2;
            float _Val;

            fixed4 frag(v2f i) : SV_Target
            {
                if (i.worldPos.y > _Val)
                    discard;

                return _Color2;
            }
            ENDCG
        }

        //  PASS 3
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
            };

            float _EdgeWidth;

            v2f vert(appdata_full v)
            {
                v2f o;
                v.vertex.xyz *= _EdgeWidth;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 _Color2;
            float _Val;

            fixed4 frag(v2f i) : SV_Target
            {
                if (i.worldPos.y > _Val)
                    discard;

                return _Color2;
            }
            ENDCG
        }

        //  PASS 4
        Cull Front

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0
        struct Input
        {
            float2 uv_MainTe;
            float3 worldPos;
        };

        float _EdgeWidth;

        void vert(inout appdata_full v)
        {
            v.vertex.xyz *= _EdgeWidth;
        }

        fixed4 _Color1;
        float _Val;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            if (IN.worldPos.y > _Val)
                discard;

            o.Albedo = _Color1;
        }
        ENDCG
    }
}