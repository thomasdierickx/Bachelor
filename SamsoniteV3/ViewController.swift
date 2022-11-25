//
//  ViewController.swift
//  SamsoniteV3
//
//  Created by Thomas Dierickx on 25/11/2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var modelScene: SCNScene?
    var modelSceneNode: SCNNode?
    var counter: Double = 1.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene();
        
        modelScene = SCNScene(named: "blenderModelOpen.dae");
        
        modelSceneNode = modelScene?.rootNode.childNode(withName: "ibonModelOpen", recursively: true)
        
        modelSceneNode?.position = SCNVector3(0, 0, -5.0);
        
        scene.rootNode.addChildNode(modelSceneNode!);
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func PinchGestureRecognizer(_ sender: UIPinchGestureRecognizer) {   guard sender.view != nil else { return }
        // Zoomable Case
        counter = counter + 0.1;
        print(counter);
        if (counter >= 10.0) {
            counter = 10.0;
        }
        modelSceneNode?.scale = SCNVector3(counter, counter, counter);
        
        
//        Zoomable canvas
//        if sender.state == .began || sender.state == .changed {
//            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
//            sender.scale = 1.0
//        }
    }
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
