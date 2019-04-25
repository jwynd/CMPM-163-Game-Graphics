using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PathFollower : MonoBehaviour
{
    [SerializeField][Range(1.0f,10.0f)] private float speed;
    // [SerializeField] private bool ascending = true;
    [SerializeField] private Transform[] points;

    private float distance;
    private int next;

    // Start is called before the first frame update
    void Start()
    {
        next = 0;
    }

    // Update is called once per frame
    void Update()
    {
        distance = Vector3.Distance(points[next].position, this.transform.position);
        if(distance < 0.001f){ next = (next + 1) % points.Length;}
        float step = speed * Time.deltaTime;
        this.transform.position = Vector3.MoveTowards(this.transform.position, points[next].position, step);
    }
}
