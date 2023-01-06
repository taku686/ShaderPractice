using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Flat : MonoBehaviour
{
    void FlatShading()
    {
        SkinnedMeshRenderer mf = GetComponent<SkinnedMeshRenderer>();
        Mesh mesh = Instantiate(mf.sharedMesh) as Mesh;
        mf.sharedMesh = mesh;

        Vector3[] oldVerts = mesh.vertices;
        int[] triangles = mesh.triangles;
        Vector3[] vertices = new Vector3[triangles.Length];

        for (int i = 0; i < triangles.Length; i++)
        {
            vertices[i] = oldVerts[triangles[i]];
            triangles[i] = i;
        }

        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.RecalculateNormals();
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            FlatShading();
        }
    }
}