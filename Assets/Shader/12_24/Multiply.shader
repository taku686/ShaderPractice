Shader "Unlit/Multiplay"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color) = (1,0,0,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vertInput
            {
                float4 pos : POSITION;
                float2 texcoord: TEXCOORD0;
            };

            struct vertOutput
            {
                float2 texcoord : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            half4 _Color;

            vertOutput vert(vertInput input)
            {
                vertOutput o;
                o.pos = UnityObjectToClipPos(input.pos);
                o.texcoord = input.texcoord;
                return o;
            }

            half4 frag(vertOutput output) : COLOR
            {
                half4 mainColor = tex2D(_MainTex, output.texcoord);
                return mainColor * _Color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}