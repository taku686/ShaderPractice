using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderBlendMode : MonoBehaviour
{
    public Shader curShader;
    public Texture2D blendTexture;
    public float blendOpacity = 1f;
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
        blendOpacity = Mathf.Clamp(blendOpacity, 0f, 1f);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (curShader != null)
        {
            ScreenMat.SetTexture("_BlendTex", blendTexture);
            ScreenMat.SetFloat("_Opacity", blendOpacity);
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