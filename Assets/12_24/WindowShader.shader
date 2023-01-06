Shader "Unlit/GrabShader"
{
    Properties
    {
        _MainTex("Main Tex",2D) = "white"{}
        _Color("Color",Color) = (1,1,1,1)
        _BumpMap("Bump Map",2D) = "bump"{}
        _Magnitude("Magnitude",Range(0,1)) = 0.05
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        GrabPass {}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _GrabTexture;
            sampler2D _MainTex;
            sampler2D _BumpMap;
            fixed4 _Color;
            float _Magnitude;

            struct vertInput
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct vertOutput
            {
                float4 vertex : POSITION;
                float4 uvgrab : TEXCOORD1;
                float2 texcoord : TEXCOORD0;
            };

            vertOutput vert(vertInput v)
            {
                vertOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab = ComputeScreenPos(o.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            half4 frag(vertOutput i) : COLOR
            {
                half4 mainColor = tex2D(_MainTex, i.texcoord);
                half4 bump = tex2D(_BumpMap, i.texcoord);
                half2 distortion = UnpackNormal(bump).rg;
                i.uvgrab.xy += distortion * _Magnitude;
                fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvgrab));
                return col * mainColor * _Color;
            }
            ENDCG
        }

    }
    FallBack "Diffuse"
}