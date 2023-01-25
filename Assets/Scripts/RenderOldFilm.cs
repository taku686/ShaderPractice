using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

[ExecuteInEditMode]
public class RenderOldFilm : MonoBehaviour
{
    public Shader curShader;
    public float OldFilmEffectAmount = 1.0f;
    public Color sepiaColor = Color.white;
    public Texture2D vignetteTexture;
    public float vignetteAmount = 1.0f;
    public Texture2D scratchesTexture;
    public float scratchesYSpeed = 10.0f;
    public float scratchesXSpeed = 10.0f;
    public Texture2D dustTexture;
    public float dustYSpeed = 10.0f;
    public float dustXSpeed = 10.0f;
    private Material _screenMat;
    private float _randomValue;

    Material ScreenMat
    {
        get
        {
            if (_screenMat == null)
            {
                _screenMat = new Material(curShader)
                {
                    hideFlags = HideFlags.HideAndDontSave
                };
            }

            return _screenMat;
        }
    }

    private void Start()
    {
        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    private void Update()
    {
        vignetteAmount = Mathf.Clamp01(vignetteAmount);
        OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0f, 1.5f);
        _randomValue = Random.Range(-1f, 1f);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (curShader != null)
        {
            ScreenMat.SetColor("_SpiaColor", sepiaColor);
            ScreenMat.SetFloat("_VignetteAmount", vignetteAmount);
            ScreenMat.SetFloat("_EffectAmount", OldFilmEffectAmount);
            if (vignetteTexture)
            {
                ScreenMat.SetTexture("_VignetteTex", vignetteTexture);
            }

            if (scratchesTexture)
            {
                ScreenMat.SetTexture("_ScratchesTex", scratchesTexture);
                ScreenMat.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
                ScreenMat.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
            }

            if (dustTexture)
            {
                ScreenMat.SetTexture("_DustTex", dustTexture);
                ScreenMat.SetFloat("_dustYSpeed", dustYSpeed);
                ScreenMat.SetFloat("_dustXSpeed", dustXSpeed);
                ScreenMat.SetFloat("_RandomValue", _randomValue);
            }

            Graphics.Blit(src, dest, ScreenMat);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    private void OnDisable()
    {
        if (_screenMat)
        {
            DestroyImmediate(_screenMat);
        }
    }
}