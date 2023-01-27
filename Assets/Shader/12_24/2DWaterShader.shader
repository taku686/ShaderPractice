Shader "Unlit/GrabShader"
{
    Properties
    {
        _NoiseTex("Noise Tex",2D) = "white"{}
        _Color("Color",Color) = (1,1,1,1)
        [PowerSlider] _Period("Period",range(0,50)) = 1
        _Magnitude("Magnitude",Range(0,1)) = 0.05
        _Scale("Scale",Range(0,10)) = 1
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
            sampler2D _NoiseTex;
            fixed4 _Color;
            float _Period;
            float _Magnitude;
            float _Scale;

            struct vertInput
            {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct vertOutput
            {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPos : TEXCOOR1;
                float4 uvgrab : TEXCOORD2;
            };

            vertOutput vert(vertInput v)
            {
                vertOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uvgrab = ComputeScreenPos(o.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            half4 frag(vertOutput i) : COLOR
            {
                float sinT = sin(_Time.w / _Period);
                float2 xyOverScale = i.worldPos.xy / _Scale;
                float2 xCoords = xyOverScale + float2(sinT, 0);
                float2 yCoords = xyOverScale + float2(0, sinT);
                float distX = tex2D(_NoiseTex, xCoords).r - 0.5;
                float distY = tex2D(_NoiseTex, yCoords).r - 0.5;
                float2 distortion = float2(distX, distY);
                i.uvgrab.xy += distortion * _Magnitude;
                fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvgrab));
                return col * _Color;
            }
            ENDCG
        }

    }
    FallBack "Diffuse"
}