using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderBSC : MonoBehaviour
{
    public Shader curShader;
    public float brightness = 1f;
    public float saturation = 1f;
    public float contrast = 1f;
    private Material _screenMat;

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
        brightness = Mathf.Clamp(brightness, 0f, 2f);
        saturation = Mathf.Clamp(saturation, 0f, 2f);
        contrast = Mathf.Clamp(contrast, 0f, 2f);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_Brightness", brightness);
            ScreenMat.SetFloat("_Saturation", saturation);
            ScreenMat.SetFloat("_Contrast", contrast);
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