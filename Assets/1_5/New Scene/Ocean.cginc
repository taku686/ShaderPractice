#include "Noise.cginc"
float _NoiseStrength;
float _NoiseSizeLerp;

float4 _Amplitude;
float4 _Frequency;
float4 _Steepness;
float4 _Speed;
float4 _Noise;
float4 _DirectionA;
float4 _DirectionB;

float4 _Amplitude2;
float4 _Frequency2;
float4 _Steepness2;
float4 _Speed2;
float4 _Noise2;
float4 _DirectionC;
float4 _DirectionD;

static const float amp[8] = {_Amplitude.x, _Amplitude.y, _Amplitude.z, _Amplitude.w, _Amplitude2.x, _Amplitude2.y, _Amplitude2.z, _Amplitude2.w};
static const float freq[8] = {_Frequency.x, _Frequency.y, _Frequency.z, _Frequency.w, _Frequency2.x, _Frequency2.y, _Frequency2.z, _Frequency2.w};
static const float steep[8] = {_Steepness.x, _Steepness.y, _Steepness.z, _Steepness.w, _Steepness2.x, _Steepness2.y, _Steepness2.z, _Steepness2.w};
static const float speed[8] = {_Speed.x, _Speed.y, _Speed.z, _Speed.w, _Speed2.x, _Speed2.y, _Speed2.z, _Speed2.w};
static const float2 dir[8] = {_DirectionA.xy, _DirectionA.zw, _DirectionB.xy, _DirectionB.zw, _DirectionC.xy, _DirectionC.zw, _DirectionD.xy, _DirectionD.zw};
static const float noise_size[8] = {_Noise.x, _Noise.y, _Noise.z, _Noise.w, _Noise2.x, _Noise2.y, _Noise2.z, _Noise2.w};

float4 _SeaBaseColor;
float4 _SeaShallowColor;
float _SeaColorStrength;

float _BaseColorStrength;
float _ShallowColorStrength;
float _ColorHightOffset;

float _WaveSpeed;

float4 _LightColor0;
float _Shininess;

float3 GerstnerWave(float2 amp, float freq, float steep, float speed, float noise, float2 dir, float2 v, float time, int seed)
{
	float3 p;
	float2 d = normalize(dir.xy);
	float q = steep;

	seed *= 3;
	v +=  noise2(v * noise + time, seed) * _NoiseStrength;
	float f = dot(d, v) * freq + time * speed;
	p.xz = q * amp * d.xy * cos(f);
	p.y = amp * sin(f);

	return p;
}

float3 GerstnerWave_Cross(float2 amp, float freq, float steep, float speed, float noise, float2 dir, float2 v, float time, int seed)
{
	float3 p;
	float2 d = normalize(dir.xy);
	float q = steep;

	float noise_strength = _NoiseStrength;
	seed *= 3;

	float3 p1;
	float3 p2;
	float2 d1 = normalize(dir.xy);
	float2 d2 = float2(-d.y, d.x);

	float2 v1 = v + noise2(v * noise + time * d * 10.0, seed) * noise_strength;
	float2 v2 = v + noise2(v * noise + time * d * 10.0, seed + 12) * noise_strength;
	float2 f1 = dot(d1, v1) * freq + time * speed;
	float2 f2 = dot(d2, v2) * freq + time * speed;
	p1.xz = q * amp * d1.xy * cos(f1);
	p1.y = amp * sin(f1);
	p2.xz = q * amp * d2.xy * cos(f2);
	p2.y = amp * sin(f2);

	p = lerp(p1, p2, noise2(v * _NoiseSizeLerp + time, seed) * 0.5 + 0.5);
	return p;
}

float4 _SkyColor;

float3 GetSkyColor(float3 dir, float3 c){
	dir.y = max(0.0, dir.y);
	float et = 1.0 - dir.y;
	return (1.0 - c) * et + c;
}
			
float3 OceanColor(float3 world_pos, float wave_height, float3 normal, float4 proj_coord){
	//lighting
	float3 lightDir = normalize(UnityWorldSpaceLightDir(world_pos));
	float3 viewDir = normalize(UnityWorldSpaceViewDir(world_pos));
	float3 halfDir = normalize(lightDir + viewDir);
	
	//fresnel
	float r = 0.02;
	float facing = saturate(1.0 - dot(normal, viewDir));
	float fresnel = r + (1.0 - r) * pow(facing, 5.0);
	float3 reflectDir = reflect(-viewDir, normal);
	
	float diff = saturate(dot(normal, lightDir)) * _LightColor0;
	//float spec = pow(max(0.0, dot(normal, halfDir)), _Shininess * 128.0) * _LightColor0;	//Blinn-Phong
	
	//https://www.gamedev.net/articles/programming/graphics/rendering-water-as-a-post-process-effect-r2642/
	float dotSpec = saturate(dot(reflectDir, lightDir) * 0.5 + 0.5);
	float spec = (1.0 - fresnel) * saturate(lightDir.y) * pow(dotSpec, 512.0) * (_Shininess * 1.8 + 0.2);
	spec += spec * 25.0 * saturate(_Shininess - 0.05) * _LightColor0;
	
	//reflection
	float3 sea_reflect_color = GetSkyColor(reflectDir, _SkyColor);
	float3 sea_base_color = _SeaBaseColor * diff * _BaseColorStrength + lerp(_SeaBaseColor, _SeaShallowColor * _ShallowColorStrength, diff);
	float3 water_color = lerp(sea_base_color, sea_reflect_color, fresnel);
	float3 sea_color = water_color + _SeaShallowColor * (wave_height * 0.5 + 0.2) * _ColorHightOffset;

	return sea_color;
}