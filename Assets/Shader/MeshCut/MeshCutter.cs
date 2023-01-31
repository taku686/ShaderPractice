using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MeshCutter : MonoBehaviour
{
    private bool _isCut;

    private void Start()
    {
        _isCut = true;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!_isCut)
        {
            return;
        }

        _isCut = false;
        var obj = other.gameObject;
        var transform1 = other.transform;
        var pos = transform1.position;
        var nol = transform.up;
        var mat = other.GetComponent<MeshRenderer>().material;

        var victims = MeshCut.Cut(obj, pos, nol, mat);
        foreach (var victim in victims)
        {
            var rigid = victim.GetComponent<Rigidbody>();
            if (rigid == null)
            {
                rigid = victim.AddComponent<Rigidbody>();
            }

            rigid.useGravity = true;

            var col = victim.GetComponent<MeshCollider>();
            if (col == null)
            {
                col = victim.AddComponent<MeshCollider>();
            }

            col.convex = true;
            col.isTrigger = false;
            StartCoroutine(WaitToCut());
        }
    }

    private IEnumerator WaitToCut()
    {
        yield return new WaitForSeconds(0.2f);
        _isCut = true;
    }
}