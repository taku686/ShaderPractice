Shader "Unlit/Shield"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color" ,color) = (1,1,1,1)
        _RimEffect("Rim effect",range(0,1)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
        }
        LOD 100
        Blend One One
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _RimEffect;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = normalize(mul(unity_ObjectToWorld, v.normal));
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                //o.uv = v.texcoord;
                o.viewDir = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, v.vertex));
                return o;
            }

            fixed4 frag(v2f i): COLOR
            {
                float t = tex2D(_MainTex, i.uv);
                float val = 1 - abs(dot(i.viewDir, i.normal)) * _RimEffect;
                return _Color * _Color.a * val * val * t;
            }
            ENDCG
        }
    }
}