using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnEnemy : MonoBehaviour
{
    public List<Transform> spawnPos;
    public GameObject enemyPrefab;
    public float spawnTime = 10f;

    private float lastSpawnTime;

    // Start is called before the first frame update
    void Start()
    {
        foreach (Transform child in transform)
        {
            spawnPos.Add(child);
        }

        if (spawnPos.Count == 0 || enemyPrefab == null)
        {
            Debug.Log("No spawn position or enemy prefab assigned");
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time - lastSpawnTime > spawnTime)
        {
            int rundomNum = Random.Range(0, spawnPos.Count - 1);

            Instantiate(enemyPrefab, spawnPos[rundomNum].transform);
            lastSpawnTime = Time.time;
        }
    }
}
