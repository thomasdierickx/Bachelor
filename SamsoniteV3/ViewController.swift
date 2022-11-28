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
    var counter: Double = 0.01;
    
    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showAdded(to: self.sceneView, animated: true);
        self.hud.label.text = "Detecting Plane..."
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene();
        
        modelScene = SCNScene(named: "blenderModelOpen.dae");
        
        modelSceneNode = modelScene?.rootNode.childNode(withName: "ibonModelOpen", recursively: true)
        
        modelSceneNode?.position = SCNVector3(0, -3.0, -5.0);
        
        scene.rootNode.addChildNode(modelSceneNode!);
        
        // Create 3D text
        let text = SCNText(string: "Samsonite IBON", extrusionDepth: 2);
        let bodyText = SCNText(string: "De IBON collectie, gelanceerd in 2021, is een pionier \n op het gebied van innovatie en design. De opening bevindt \n zich aan de voorkant van de koffer, waardoor de oppervlakte \n die de valies inneemt hetzelfde blijft wanneer deze geopend is. \n Alle spullen van de reiziger blijven veilig opgeborgen dankzij de \n eenpuntssluiting met geïntegreerd TSA-slot.", extrusionDepth: 1)
        
        // Create & Add color
        let material = SCNMaterial();
        material.diffuse.contents = UIColor.red;
        material.diffuse.contents = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.black)
        text.materials = [material];
        
        let materialWhite = SCNMaterial();
        materialWhite.diffuse.contents = UIColor.white;
        material.diffuse.contents = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        bodyText.materials = [materialWhite]
        
        // Creates node object & positions it
        let node = SCNNode();
        node.position = SCNVector3(-2.0, -3.0, -5.0);
        node.scale = SCNVector3(x: 0.05, y: 0.05, z: 0.05);
        node.geometry = text;
        
        let nodeBodyText = SCNNode();
        nodeBodyText.position = SCNVector3(-2.0, -5.0, -5.0);
        nodeBodyText.scale = SCNVector3(x: 0.02, y: 0.02, z: 0.02);
//        nodeBodyText.
        nodeBodyText.geometry = bodyText;
        
        // Set the scene & elements to the view
        sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(node);
        sceneView.autoenablesDefaultLighting = true; // Adds lighting and shadows
        sceneView.scene.rootNode.addChildNode(nodeBodyText);
        sceneView.autoenablesDefaultLighting = true;
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            DispatchQueue.main.async {
                self.hud.label.text = "Plane Detected"
                self.hud.hide(animated: true, afterDelay: 1.0)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func PinchGestureRecognizer(_ sender: UIPinchGestureRecognizer) {   guard sender.view != nil else { return }
        // Zoomable case
        if sender.state == .began || sender.state == .changed {
            counter = sender.scale / 30;
            print(counter);
            modelSceneNode?.scale = SCNVector3(counter, counter, counter);
        }
    }
    
    
    @IBAction func ChangePosition(_ sender: UILongPressGestureRecognizer) {
        let touch = sender.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlane)
        
        modelSceneNode?.position = SCNVector3(touch.x / 100, -3.0, touch.y / 100)
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
