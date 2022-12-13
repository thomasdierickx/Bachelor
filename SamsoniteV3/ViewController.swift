//
//  ViewController.swift
//  SamsoniteV3
//
//  Created by Thomas Dierickx on 25/11/2022.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import ARKit

@available(iOS 14.0, *)
class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var modelScene: SCNScene = SCNScene()
    var modelSceneNode: SCNNode = SCNNode()
    
    var modelSceneOpen: SCNScene = SCNScene()
    var modelSceneNodeOpen: SCNNode = SCNNode()
    
    var nodeCarText: SCNNode = SCNNode();
    
    var modelGlobal: SCNScene = SCNScene()
    var modelRoomNode: SCNNode = SCNNode();
    var modelCarNode: SCNNode = SCNNode();
    
    // Intro
    var node: SCNNode = SCNNode();
    var nodeBodyText: SCNNode = SCNNode();
    // Part 1
    var nodeInstr: SCNNode = SCNNode();
    var nodeInstrText: SCNNode = SCNNode();
    
    var configuration = ARWorldTrackingConfiguration()
    
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
        modelGlobal = SCNScene(named: "art.scnassets/GlobalScene.scn")!
        modelSceneNode = modelGlobal.rootNode.childNode(withName: "IBON", recursively: true)!
        modelSceneNode.isHidden = true

        scene.rootNode.addChildNode(modelSceneNode);

        modelSceneNodeOpen = modelGlobal.rootNode.childNode(withName: "IBONOPEN", recursively: true)!
        modelSceneNodeOpen.isHidden = true
        
        modelSceneNode.childNodes[9].childNodes[3].geometry?.firstMaterial?.diffuse.contents = UIColor.white
        modelSceneNodeOpen.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.white

        scene.rootNode.addChildNode(modelSceneNodeOpen);
        
        modelRoomNode = modelGlobal.rootNode.childNode(withName: "Hotelroom", recursively: true)!
        modelRoomNode.isHidden = true
        modelCarNode = modelGlobal.rootNode.childNode(withName: "Car", recursively: true)!
        modelCarNode.isHidden = true
        
        scene.rootNode.addChildNode(modelRoomNode)
        scene.rootNode.addChildNode(modelCarNode)
        
        
        // Create 3D text
        let text = SCNText(string: "Hello!", extrusionDepth: 2);
        text.font = UIFont(name: "Helvetica", size: 10)
        let bodyText = SCNText(string: "I'm the new Samsonite case called Ibon. I can \n practically fit anywhere or you can even fit anything inside of me! \n Go ahead and give it a try. Touch the \n lock to open me. You can also drag me \n everywhere you want!", extrusionDepth: 1)
        bodyText.font = UIFont(name: "Helvetica", size: 10)
        
        let carText = SCNText(string: "Do i fit in here?", extrusionDepth: 2)
        carText.font = UIFont(name: "Helvetica", size: 10)
        
        // Intro
        // Create & Add color
        let material = SCNMaterial();
        material.diffuse.contents = UIColor.red;
        text.materials = [material];
        carText.materials = [material]
        
        // Creates node object & positions it
        node.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        node.position.z = -3
        node.geometry = text;
        node.isHidden = true
        
        nodeCarText.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        nodeCarText.position = SCNVector3(x: -9, y: 1.5, z: -1.5)
        nodeCarText.eulerAngles = SCNVector3(0, 2.0, 0)
        nodeCarText.geometry = carText;
        nodeCarText.isHidden = true
        
        let materialWhite = SCNMaterial();
        materialWhite.diffuse.contents = UIColor.white;
        bodyText.materials = [materialWhite]
        nodeBodyText.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01);
        nodeBodyText.position.y = -0.7;
        nodeBodyText.position.z = -3
        nodeBodyText.geometry = bodyText;
        nodeBodyText.isHidden = true
        
        // Part 1
        let titleInstr = SCNText(string: "Instructions", extrusionDepth: 2);
        titleInstr.materials = [material];
        titleInstr.font = UIFont(name: "Helvetica", size: 10)
        nodeInstr.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        nodeInstr.position.y = -50;
        nodeInstr.position.z = -3
        nodeInstr.geometry = titleInstr;
        nodeInstr.isHidden = true
        
        let bodyInstrText = SCNText(string: "Swipe right for next text \n Swipe left for previous text \n Move slider to see the real life size \n Tap to change the colors \n Click on the lock to open it \n Experiment and enjoy!", extrusionDepth: 1)
        bodyInstrText.materials = [materialWhite]
        bodyInstrText.font = UIFont(name: "Helvetica", size: 10)
        nodeInstrText.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01);
        nodeInstrText.position.y = -50.7;
        nodeInstrText.position.z = -3
        nodeInstrText.geometry = bodyInstrText;
        nodeInstrText.isHidden = true
        
        // Set the scene & elements to the view
        sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(node);
        sceneView.autoenablesDefaultLighting = true; // Adds lighting and shadows
        sceneView.scene.rootNode.addChildNode(nodeBodyText);
        sceneView.scene.rootNode.addChildNode(nodeInstr);
        sceneView.scene.rootNode.addChildNode(nodeInstrText);
        sceneView.scene.rootNode.addChildNode(nodeCarText)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Swiping(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Swiping(_:)))

        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        sceneView.addGestureRecognizer(leftSwipe)
        sceneView.addGestureRecognizer(rightSwipe)
        
        // Add pan gesture for dragging the textNode about
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
        if anchor is ARPlaneAnchor {
            DispatchQueue.main.async {
                self.hud.label.text = "Plane Detected"
                self.hud.hide(animated: true, afterDelay: 1.0)
            }
            OnlyLoadWhenPlaneLoads()
        }
    }
    
    func OnlyLoadWhenPlaneLoads() {
        
        modelSceneNode.isHidden = false
        node.isHidden = false
        nodeBodyText.isHidden = false
        nodeInstr.isHidden = false
        nodeInstrText.isHidden = false
        modelCarNode.isHidden = false
        nodeCarText.isHidden = false
        modelRoomNode.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func SliderRotation(_ sender: UISlider) {
        if (modelSceneNode.isHidden == false) {
            sender.minimumValue = -1.57
            sender.maximumValue = 0
        } else {
            sender.minimumValue = 0
            sender.maximumValue = 1.57
        }

        print(sender.value)
        modelSceneNode.eulerAngles = SCNVector3(x: 1.5, y: 0, z: sender.value)
        modelSceneNodeOpen.eulerAngles = SCNVector3(x: sender.value, y: 0, z: 0)
    }
    
    @IBAction func Swiping(_ sender: UISwipeGestureRecognizer) {
        let arrNodes = [node, nodeBodyText, nodeInstr, nodeInstrText];
        
        switch sender.direction{
            case .left:
                for arrNode in arrNodes {
                    arrNode.position.y = arrNode.position.y - 51
                }
            case .right:
                for arrNode in arrNodes {
                    arrNode.position.y = arrNode.position.y + 51
                }
            default://default
                print("default")
            }
    }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        
        gesture.minimumNumberOfTouches = 1
        
        let raycastQuery: ARRaycastQuery? = sceneView.raycastQuery(
                                                              from: sceneView.center,
                                                          allowing: .estimatedPlane,
                                                         alignment: .any)

        let resultsRay: [ARRaycastResult] = sceneView.session.raycast(raycastQuery!)
        
        if !resultsRay.isEmpty {
            let resultRay: [ARRaycastResult] = [resultsRay.first!]
            
            let posRay = SCNVector3Make(resultRay[0].worldTransform.columns.3.x, resultRay[0].worldTransform.columns.3.y, resultRay[0].worldTransform.columns.3.z)
            
            modelSceneNode.position = posRay
            modelSceneNodeOpen.position = posRay
        } else {
            print("resultsRay is empty")
        }

//        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
//        guard let result: ARHitTestResult = results.first else {
//            return
//        }

//        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
    }
    
    @IBAction func ResetScene(_ sender: UIButton) {
        sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        viewDidLoad()
    }
    
    @IBAction func OpenCloseCase(_ sender: UIButton) {
        if modelSceneNode.isHidden == false {
            modelSceneNode.isHidden = true
            let loadingNotification = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
            loadingNotification.mode = MBProgressHUDMode.customView
            loadingNotification.label.text = "Good job, the case is open!"
            modelSceneNodeOpen.isHidden = false
            loadingNotification.hide(animated: true, afterDelay: 1.0)
            sender.setTitle("CLOSE ME", for: .normal)
        } else {
            modelSceneNodeOpen.isHidden = true
            let loadingNotification = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
            loadingNotification.mode = MBProgressHUDMode.customView
            loadingNotification.label.text = "Good job, the case is closed!"
            modelSceneNode.isHidden = false
            loadingNotification.hide(animated: true, afterDelay: 1.0)
            sender.setTitle("OPEN ME", for: .normal)
        }
    }
    
    var objectRotation: Float {
        get {
            return (modelSceneNode.childNodes.first!.eulerAngles.y)
        }
        set (newValue) {
            modelSceneNode.childNodes.first!.eulerAngles.y = newValue
        }
    }
    
    @IBAction func RotateCase(_ sender: UIRotationGestureRecognizer) {
        guard sender.state == .changed else { return }
        
        print(sender)
        
        modelSceneNode.eulerAngles.y += Float(sender.rotation)
        modelSceneNodeOpen.eulerAngles.y += Float(sender.rotation)
        
        sender.rotation = 0
    }
    
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
