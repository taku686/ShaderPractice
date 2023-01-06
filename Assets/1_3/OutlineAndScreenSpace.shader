Shader "Unlit/OutlineAndScreenSpace"
{
    Properties
    {
        [Headr(Outline)]
        _OutlineVal("Outline Val",range(0,2)) = 1
        _OutlineCol("Outline Color",color) = (1,1,1,1)
        [Header(Texture)]
        _MainTex ("Texture", 2D) = "white" {}
        _Zoom("Zoom",range(0.5,20)) = 1
        _SpeedX("Speed along X",range(-1,1)) = 0
        _SpeedY("Speed along Y",range(-1,1)) = 0
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            cull front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            float _OutlineVal;
            fixed4 _OutlineCol;

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul(unity_MatrixMVP, v.vertex);

                // Convert normal to view space (camera space)
                float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);

                normal.x *= UNITY_MATRIX_P[0][0];
                normal.y *= UNITY_MATRIX_P[1][1];

                o.pos.xy += _OutlineVal * normal.xy;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _OutlineCol;
            }
            ENDCG
        }
        Pass
        {


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _Zoom;
            float _SpeedX;
            float _SpeedY;

            float4 vert(appdata_base v) : SV_POSITION
            {
                return mul(unity_MatrixMVP, v.vertex);
            }


            fixed4 frag(float4 i : VPOS) : SV_Target
            {
                return tex2D(
                    _MainTex, ((i.xy / _ScreenParams.xy) + float2(_Time.y * _SpeedX, _Time.y * _SpeedY)) / _Zoom);
            }
            ENDCG
        }
    }
}