Shader "Unlit/TextureDependingLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondaryTex("Texture In Shadow",2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "LightMode" = "FowardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _SecondaryTex;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float light : TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                o.light = max(0, dot(worldNormal, lightDir));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col1 = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_SecondaryTex, i.uv);
                return lerp(col1, col2, i.light);
            }
            ENDCG
        }
    }
}