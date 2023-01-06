Shader "Unlit/Water2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RefTex("Reflection Tex",cube) = "" {}
        _BumpMap("Bump Tex",2D) = "white" {}
        _DispTex("Disp Texture", 2D) = "gray" {}
        _ScrollSpeedX("Speed x",float) = 0
        _ScrollSpeedY("Speed y",float) = 0
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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _BumpMap;
            sampler2D _DispTex;
            float4 _DispTex_TexelSize;
            float4 _MainTex_ST;
            float4 _DispTex_ST;
            float _ScrollSpeedX;
            float _ScrollSpeedY;
            UNITY_DECLARE_TEXCUBE(_RefTex);
            #define F0 0.9

            struct v2f
            {
                float2 uv :TEXCOORD0;
                float4 vertex :SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 tangent : TEXCOORD3;
                float3 binormal : TEXCOORD4;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _DispTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = normalize(mul(unity_ObjectToWorld, v.tangent)).xyz;
                o.binormal = cross(o.normal, o.tangent) * v.tangent.w;
                o.binormal = normalize(mul(unity_ObjectToWorld, o.binormal));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 scroll = float2(_ScrollSpeedX, _ScrollSpeedY) * _Time;
                float3 normal = UnpackNormal(tex2D(_BumpMap, i.uv + scroll));
                normal = i.tangent * normal.x + i.binormal * normal.y + i.normal * normal.z;
                float3 duv = float3(_DispTex_TexelSize.xy, 0);
                half v1 = tex2D(_DispTex, i.uv - duv.xz).y;
                half v2 = tex2D(_DispTex, i.uv + duv.xz).y;
                half v3 = tex2D(_DispTex, i.uv - duv.zy).y;
                half v4 = tex2D(_DispTex, i.uv + duv.zy).y;
                normal += normalize(float3(v1 - v2, v3 - v4, 0.3));
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos); //視線ベクトルを計算
                float3 refDir = reflect(-viewDir, normal); //反射ベクトルを計算
                fixed4 col;
                col = UNITY_SAMPLE_TEXCUBE(_RefTex, refDir);
                half vdotn = dot(viewDir, normal);
                half fresnel = F0 + (1 - F0) * pow(1 - vdotn, 5);
                col.a = fresnel;
                return col;
            }
            ENDCG
        }
    }
}