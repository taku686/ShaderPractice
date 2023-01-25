using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour
{
    public Shader curShader;
    public float greyscaleAmount = 1f;
    public float depthPower = 0.2f;
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
        greyscaleAmount = Mathf.Clamp(greyscaleAmount, 0.0f, 1.0f);
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        depthPower = Mathf.Clamp(depthPower, 0, 1);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_DepthPower", depthPower);
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