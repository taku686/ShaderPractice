Shader "Unlit/Block2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
            "IgonoreProgector" = "True"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite off
        Cull off
        LOD 100

        Pass
        {
            Stencil
            {
                Ref 1
                Comp Equal
            }
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;

            fixed4 frag(v2f_img i) : COLOR
            {
              float alpha = tex2D(_MainTex, i.uv).a;
                fixed4 col = fixed4(1,0,0,alpha);
                return col;
            }
            ENDCG
        } Pass
        {
            Stencil
            {
                Ref 0
                Comp Equal
            }
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}