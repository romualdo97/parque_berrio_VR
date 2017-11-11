using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveForward : MonoBehaviour {

    public float speed = 0.5f;

	// Use this for initialization
	void Start ()
    {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (gameObject.transform.position.x > 508)
        {
            gameObject.transform.position += gameObject.transform.forward * speed;
            gameObject.transform.Rotate(new Vector3(1f, 0f, 0f), Mathf.Sin(Time.realtimeSinceStartup * 5f) * 0.08f);
            gameObject.transform.Rotate(new Vector3(0f, 0f, 1f), Mathf.Sin(Time.realtimeSinceStartup * 5f) * 0.06f);
        }

        if (Input.GetKey(KeyCode.R)) Reset();
    }

    void Reset()
    {
        gameObject.transform.position = new Vector3(700f, -8f, 241f);
    }
}
