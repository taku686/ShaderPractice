Shader "Unlit/SwitchTexture"
{
    Properties
    {
        _PlayerPos("Player Pos",vector) = (0,0,0)
        _Dist("Distance",float) = 5.0
        _MainTex ("Texture", 2D) = "white" {}
        _SecondaryTex("Secondary Texture",2D) = "white"{}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _PlayerPos;
            sampler2D _SecondaryTex;
            float _Dist;


            v2f vert(appdata_base v)
            {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                if (distance(_PlayerPos.xyz, i.worldPos.zyz) > _Dist)
                {
                    return tex2D(_MainTex, i.uv);
                }
                return tex2D(_SecondaryTex, i.uv);
            }
            ENDCG
        }
    }
}