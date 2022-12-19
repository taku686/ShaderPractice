using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiplayDepth : MonoBehaviour
{
    public Material mat;

    private void Start()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}