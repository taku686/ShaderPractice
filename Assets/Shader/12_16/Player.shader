Shader "Custom/Player"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
        }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite off
        Pass
        {
            stencil
            {
                Ref 1
                Comp Equal
            }
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float alpha = tex2D(_MainTex, i.uv).a;
                fixed4 col = fixed4(0, 0, 0, alpha);
                return col;
            }
            ENDCG
        } Pass
        {
            stencil
            {
                Ref 0
                Comp Equal
            }
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;

            fixed4 frag(v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}