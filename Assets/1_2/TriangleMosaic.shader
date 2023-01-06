Shader "Unlit/TriangleMosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TileNumX("Tile Number along X",float ) = 0
        _TileNumY("Tile Number along Y",float ) = 0
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

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _TileNumX;
            float _TileNumY;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenuv : TEXCOORD1;
            };


            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul(unity_MatrixMVP, v.vertex);
                o.screenuv = ComputeScreenPos(o.pos);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float2 uv = i.screenuv.xy / i.screenuv.w;
                float2 TileNum = float2(_TileNumX, _TileNumY);
                float2 uv2 = floor(uv * TileNum) / TileNum;
                uv -= uv2;
                uv *= TileNum;


                fixed4 col = tex2D(_MainTex, uv2 + float2(step(1 - uv.y, uv.x) / (2 * _TileNumX),
                                                          step(uv.x, uv.y) / (2 * _TileNumY)));

                return col;
            }
            ENDCG
        }
    }
}