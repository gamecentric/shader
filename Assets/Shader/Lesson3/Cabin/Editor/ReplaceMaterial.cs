using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ReplaceMaterial : EditorWindow
{
    // Add menu named "My Window" to the Window menu
    [MenuItem("Window/Replace Material")]
    static void Init()
    {
        // Get existing open window or if none, make a new one:
        ReplaceMaterial window = EditorWindow.GetWindow<ReplaceMaterial>();
        window.Show();
    }

    Material from;
    Material to;

    void OnGUI()
    {
        GUILayout.Label("Source Material", EditorStyles.boldLabel);
        from = EditorGUILayout.ObjectField(from, typeof(Material), false) as Material;
        GUILayout.Label("Target Material", EditorStyles.boldLabel);
        to = EditorGUILayout.ObjectField(to, typeof(Material), false) as Material;

        if (GUILayout.Button("Replace"))
        {
            foreach (MeshRenderer rend in FindObjectsOfType<MeshRenderer>())
            {
                if (rend.sharedMaterial == from)
                {
                    rend.sharedMaterial = to;
                }
            }
        }
    }
}
