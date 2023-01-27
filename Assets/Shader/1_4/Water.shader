Shader "Custom/Water"
{
    Properties
    {
        _HorizontalColor("Horizon Color",color) = (0.172, .463 , .435 , 0)
        _WaveScale("Wave Scale",range(0.02,2)) = 0.07
        [NoScaleOffset] _ColorControl("Refective Color",2D) = "white"{}
        [NoScaleOffset] _BumpMap("Waves NormalMap",2D) = "white"{}
        _WaveSpeed("Wave Speed",vector) = (19,9,-16,-7)
    }
    CGINCLUDE
    #include "UnityCG.cginc"
    uniform float4 _HorizontalColor;
    uniform float4 _WaveSpeed;
    uniform float4 _WaveOffset;
    uniform float _WaveScale;


    struct appdata
    {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
    };

    struct v2f
    {
        float4 pos : SV_POSITION;
        float2 bumpuv[2] : TEXCOORD0;
        float3 viewDir : TEXCOORD2;
    };

    v2f vert(appdata v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);

        float4 temp;
        float4 wpos = mul(unity_ObjectToWorld, v.vertex);
        temp.xyzw = wpos.xzxz * _WaveScale + _WaveOffset;
        o.bumpuv[0] = temp.xy + float2(0.4, 0.45);
        o.bumpuv[1] = temp.wz;


        o.viewDir.xyz = normalize(WorldSpaceViewDir(v.vertex));
        return o;
    }
    ENDCG

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _BumpMap;
            sampler2D _ColorControl;

            half4 frag(v2f i) : COLOR
            {
                half3 bump1 = UnpackNormal(tex2D(_BumpMap, i.bumpuv[0])).rgb;
                half3 bump2 = UnpackNormal(tex2D(_BumpMap, i.bumpuv[1])).rgb;
                half3 bump = (bump1 + bump2) * 0.5;

                half fresnel = dot(i.viewDir, bump);
                half4 water = tex2D(_ColorControl, float2(fresnel, fresnel));

                half4 col;
                col.rgb = lerp(water.rgb, _HorizontalColor.rgb, water.a);
                col.a = _HorizontalColor.a;

                return col;
            }
            ENDCG

        }


    }
    FallBack "Diffuse"
}