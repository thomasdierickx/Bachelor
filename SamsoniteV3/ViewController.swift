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
    
    @IBOutlet var ColorHandle: UIColorWell!
    
    var modelScene: SCNScene?
    var modelSceneNode: SCNNode?
    
    var modelSceneOpen: SCNScene?
    var modelSceneNodeOpen: SCNNode?
    
    var modelCar: SCNScene?
    var modelCarNode: SCNNode?
    var nodeCarText: SCNNode = SCNNode();
    
    // Intro
    var node: SCNNode = SCNNode();
    var nodeBodyText: SCNNode = SCNNode();
    // Part 1
    var nodeInstr: SCNNode = SCNNode();
    var nodeInstrText: SCNNode = SCNNode();
    
    var lastPanLocation: SCNVector3?
    var panStartZ: CGFloat?
    var geometryNode: SCNNode = SCNNode()
    
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
        modelScene = SCNScene(named: "art.scnassets/IbonClosedSmall.scn");
        modelSceneNode = modelScene?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNode?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNode!);

        modelSceneOpen = SCNScene(named: "art.scnassets/IbonOpenSmall.scn");
        modelSceneNodeOpen = modelSceneOpen?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeOpen?.isHidden = true
        
        modelSceneNode?.childNodes[9].childNodes[3].geometry?.firstMaterial?.diffuse.contents = UIColor.white
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.white

        scene.rootNode.addChildNode(modelSceneNodeOpen!);
        
        modelCar = SCNScene(named: "art.scnassets/Car.scn");
        modelCarNode = modelCar?.rootNode.childNode(withName: "Car", recursively: true)
        modelCarNode?.isHidden = true
        modelCarNode?.position.z = -3
        
        
        scene.rootNode.addChildNode(modelCarNode!)
        
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
        
        modelSceneNode?.isHidden = false
        node.isHidden = false
        nodeBodyText.isHidden = false
        nodeInstr.isHidden = false
        nodeInstrText.isHidden = false
        modelCarNode?.isHidden = false
        nodeCarText.isHidden = false
        
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
        sender.minimumValue = 0
        sender.maximumValue = 6.2
        modelSceneNode?.eulerAngles = SCNVector3(x: 1.5, y: 0, z: sender.value)
        modelSceneNodeOpen?.eulerAngles = SCNVector3(x: 1.5, y: 0, z: sender.value)
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self.view)
//        print(location.x, location.y)
//
//        let results = self.sceneView.hitTest(CGPoint(x: 0,y: 0), options: [SCNHitTestOption.rootNode: modelSceneNode!])
//
//        let resultsOpen = self.sceneView.hitTest(CGPoint(x: 0,y: 0), options: [SCNHitTestOption.rootNode: modelSceneNodeOpen!])
//
//        if modelSceneNode?.isHidden == false {
//            if !results.isEmpty {
//                if results[0].node.name != "CaseLeft" || results[0].node.name != "CaseRight" {
////                    print("je klikt op de case")
//                }
//
//                let nameArrs = ["HandleMiddleLeft", "HandleMiddleRight", "HandleTopLeft", "HandleTopRight", "ExtendHandle"]
//
//                for nameArr in nameArrs {
//                    if results[0].node.name == nameArr {
////                        print(nameArr)
//                    }
//                }
//            } else {
////                print("je object bestaat niet")
//            }
//        }
//
//        if modelSceneNodeOpen?.isHidden == false {
//            if !resultsOpen.isEmpty {
//                if resultsOpen[0].node.name != "CaseLeft" || resultsOpen[0].node.name != "CaseRight" {
////                    print("je klikt op de case")
//                }
//
//                let nameArrs = ["HandleMiddleLeft", "HandleMiddleRight", "HandleTopLeft", "HandleTopRight", "ExtendHandle"]
//
//                for nameArr in nameArrs {
//                    if resultsOpen[0].node.name == nameArr {
////                        print(nameArr)
//                    }
//                }
//            } else {
////                print("je object bestaat niet Open")
//            }
//        }
//    }
    
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {

        gesture.minimumNumberOfTouches = 2

        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        guard let result: ARHitTestResult = results.first else {
            return
        }
        
        let oldPos = modelSceneNode?.position
        let oldPosOpen = modelSceneNodeOpen?.position
        
        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        
        if !results.isEmpty {
            modelSceneNode?.position = position
            modelSceneNodeOpen?.position = position
        } else {
            modelSceneNode?.position = oldPos!
            modelSceneNodeOpen?.position = oldPosOpen!
        }
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
        if modelSceneNode?.isHidden == false {
            modelSceneNode?.isHidden = true
            let loadingNotification = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
            loadingNotification.mode = MBProgressHUDMode.customView
            loadingNotification.label.text = "Good job, the case is open!"
            modelSceneNodeOpen?.isHidden = false
            loadingNotification.hide(animated: true, afterDelay: 1.0)
            sender.setTitle("CLOSE ME", for: .normal)
        } else {
            modelSceneNodeOpen?.isHidden = true
            let loadingNotification = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
            loadingNotification.mode = MBProgressHUDMode.customView
            loadingNotification.label.text = "Good job, the case is closed!"
            modelSceneNode?.isHidden = false
            loadingNotification.hide(animated: true, afterDelay: 1.0)
            sender.setTitle("OPEN ME", for: .normal)
        }
    }
    
    var objectRotation: Float {
        get {
            return (modelSceneNode?.childNodes.first!.eulerAngles.y)!
        }
        set (newValue) {
            modelSceneNode?.childNodes.first!.eulerAngles.y = newValue
        }
    }
    
    @IBAction func RotateCase(_ sender: UIRotationGestureRecognizer) {
        guard sender.state == .changed else { return }
        
        print(sender)
        
        modelSceneNode?.rotation.y += Float(sender.rotation)
        modelSceneNodeOpen?.rotation.x += Float(sender.rotation)
        
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
