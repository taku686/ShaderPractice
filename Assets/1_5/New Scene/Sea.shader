Shader "Ocean/OceanColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "gray" {}

        _WaveSpeed("Value", Float) = 1.0

        [Header(OceanColor)]
        _SeaBaseColor ("SeaBaseColor", Color) = (0, 0, 0, 1)
        _SeaShallowColor ("SeaShallowColor", Color) = (0, 0, 0, 1)
        _BaseColorStrength ("Base Color Strength", Range(0, 2.0)) = 0.5
        _ShallowColorStrength ("Shallow Color Strength", Range(0, 1.0)) = 0.36
        _ColorHightOffset ("Color Hight Offset", Range(0, 1.0)) = 0.15

        [Header(SkyColor)]
        _SkyColor ("SkyColor", Color) = (0, 0, 0, 1)

        [Header(GerstnerWave)]
        _Amplitude ("Amplitude", Vector) = (0.78, 0.81, 0.6, 0.27)
        _Frequency ("Frequency", Vector) = (0.16, 0.18, 0.21, 0.27)
        _Steepness ("Steepness", Vector) = (1.70, 1.60, 1.20, 1.80)
        _Speed ("Speed", Vector) = (24, 40, 48, 60)
        _Noise ("Noise", Vector) = (0.39, 0.31, 0.27, 0.57)
        _DirectionA ("Wave A(X,Y) and B(Z,W)", Vector) = (0.35, 0.31, 0.08, 0.60)
        _DirectionB ("C(X,Y) and D(Z,W)", Vector) = (-0.95, -0.74, 0.7, -0.5)

        _Amplitude2 ("Amplitude", Vector) = (0.17, 0.12, 0.21, 0.06)
        _Frequency2 ("Frequency", Vector) = (0.7, 0.84, 0.54, 0.80)
        _Steepness2 ("Steepness", Vector) = (1.56, 2.18, 2.80, 1.90)
        _Speed2 ("Speed", Vector) = (32, 40, 48, 60)
        _Noise2 ("Noise", Vector) = (0.33, 0.81, 0.39, 0.45)
        _DirectionC ("Wave A(X,Y) and B(Z,W)", Vector) = (0.7, 0.6, 0.10, 0.38)
        _DirectionD ("C(X,Y) and D(Z,W)", Vector) = (0.43, 0.07, 0.42, 0.61)

        _NoiseSizeLerp("Noise Size", Range(0, 0.5)) = 0.5
        _NoiseStrength("Noise Strength", Range(0, 5)) = 1.26

        _Shininess ("Shininess", Range(0 ,5)) = 0.27
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/1_5/New Scene/Ocean.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 world_pos : TEXCOORD1;
                float4 proj_coord : TEXCOORD5;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            static const int wave_number = 8;
            static const int count = 4;

            v2f vert(appdata v)
            {
                v2f o;
                float4 vt = v.vertex;
                float4 world_pos = mul(unity_ObjectToWorld, vt);
                o.world_pos = world_pos.xyz;

                float time = _Time.x * _WaveSpeed;

                float3 p = 0.0;
                for (int i = 0; i < count; i++)
                {
                    p += GerstnerWave(amp[i], freq[i], steep[i], speed[i], noise_size[i], dir[i], world_pos.xz, time,
                                      i);
                }
                for (int j = wave_number - count; j < wave_number; j++)
                {
                    p += GerstnerWave_Cross(amp[j], freq[j], steep[j], speed[j], noise_size[j], dir[j], world_pos.xz,
                                            time, j);
                }
                world_pos.xyz += p;

                vt = mul(unity_WorldToObject, world_pos);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.vertex = UnityObjectToClipPos(vt);
                o.proj_coord = ComputeScreenPos(o.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //CalcNormal
                float3 world_pos = i.world_pos;
                float3 geo_pos = world_pos;

                float time = _Time.x * _WaveSpeed;

                float3 p = 0.0;
                float3 pb = float3(0.05, 0.0, 0.0);
                float3 pt = float3(0.0, 0.0, 0.05);
                float3 v_bi = world_pos.xyz + float3(0.05, 0.0, 0.0);
                float3 v_tan = world_pos.xyz + float3(0.0, 0.0, 0.05);
                for (int m = 0; m < count; m++)
                {
                    p += GerstnerWave(amp[m], freq[m], steep[m], speed[m], noise_size[m], dir[m], world_pos.xz, time,
                                      m);
                    pb += GerstnerWave(amp[m], freq[m], steep[m], speed[m], noise_size[m], dir[m], v_bi.xz, time, m);
                    pt += GerstnerWave(amp[m], freq[m], steep[m], speed[m], noise_size[m], dir[m], v_tan.xz, time, m);
                }
                for (int n = wave_number - count; n < wave_number; n++)
                {
                    p += GerstnerWave_Cross(amp[n], freq[n], steep[n], speed[n], noise_size[n], dir[n], world_pos.xz,
                                            time, n);
                    pb += GerstnerWave_Cross(amp[n], freq[n], steep[n], speed[n], noise_size[n], dir[n], v_bi.xz, time,
                                             n);
                    pt += GerstnerWave_Cross(amp[n], freq[n], steep[n], speed[n], noise_size[n], dir[n], v_tan.xz, time,
                                             n);
                }
                world_pos += p;
                float3 normal = normalize(cross(pt - p, pb - p));

                float wave_height = world_pos.y - geo_pos.y;
                float3 result = OceanColor(world_pos, wave_height, normal, i.proj_coord);

                fixed4 col = tex2D(_MainTex, i.uv) * fixed4(result, 1);
                return col;
            }
            ENDCG
        }
    }
}