using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scroll : MonoBehaviour
{
    [SerializeField] private RectTransform _rect;
    [SerializeField] private float _speed;

    private float y = 500;

    // Update is called once per frame
    void Update()
    {
        if (_rect == null)
        {
            return;
        }

        y += _speed * Time.deltaTime;
        _rect.anchoredPosition = new Vector3(0, y);
        if (y >= 1000)
        {
            y = 500f;
        }
    }
}