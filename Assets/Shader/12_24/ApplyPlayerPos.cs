using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyPlayerPos : MonoBehaviour
{
    private Material _mat;
    private GameObject _player;
    public int radius;
    private static readonly int PlayerPos = Shader.PropertyToID("_PlayerPos");
    private static readonly int Dist = Shader.PropertyToID("_Dist");

    private void Start()
    {
        _mat = GetComponent<Renderer>().material;
        _player = GameObject.FindGameObjectWithTag("Player");
    }

    private void Update()
    {
        _mat.SetVector(PlayerPos, _player.transform.position);
        _mat.SetFloat(Dist, radius);
    }
}