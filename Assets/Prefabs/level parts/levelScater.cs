using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class levelScater : MonoBehaviour
{
    public static Vector3 center;
    GameObject currentprefab;
    private Vector3 goalPosStart;
    public Vector3 goalposShow;
    public float RandomOffset = 10;
    public float Offset = 50;


    public int numIslands = 10;
    public GameObject[] islandsPrefab;
    int index;

    void Start()
    {
        goalPosStart = transform.position;
        center = transform.position;


        for (int i = 0; i < numIslands; i++)
        {
            Vector3 pos = new Vector3(Random.Range(center.x +Offset + Random.Range(0,RandomOffset), center.x - Offset + Random.Range(0, RandomOffset)),
                                      Random.Range(center.y +Offset + Random.Range(0, RandomOffset), center.y - Offset + Random.Range(0, RandomOffset)),
                                      Random.Range(center.z +Offset + Random.Range(0, RandomOffset), center.z - Offset + Random.Range(0, RandomOffset)));

            index = Random.Range(0, islandsPrefab.Length);
            currentprefab = islandsPrefab[index];
            //Instantiate(currentprefab, pos, Quaternion.identity);
            Instantiate(currentprefab, pos, Quaternion.Euler(0, 0, Random.Range(0, 360)));
            Debug.Log(currentprefab.name);
        }
    }
}
