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
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var ColorHandle: UIColorWell!
    
    var modelScene: SCNScene?
    var modelSceneNode: SCNNode?
    
    var modelSceneOpen: SCNScene?
    var modelSceneNodeOpen: SCNNode?
    
    // Loading animated ibon case
    var modelSceneAnim: SCNScene?
    var modelSceneNodeAnim: SCNNode?
    
    var counter: Double = 0.01;
    var rotateX: Float = 1.5
    var rotateY: Float = 2.5
    var rotateZ: Float = 0
    
    // Intro
    var node: SCNNode = SCNNode();
    var nodeBodyText: SCNNode = SCNNode();
    // Part 1
    var nodeInstr: SCNNode = SCNNode();
    var nodeInstrText: SCNNode = SCNNode();
    
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
        modelScene = SCNScene(named: "IbonClosedSmall.dae");
        modelSceneNode = modelScene?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNode?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNode?.position.x = -1
        modelSceneNode?.position.y = -1
        modelSceneNode?.position.z = -3
        modelSceneNode?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNode!);

        modelSceneOpen = SCNScene(named: "IbonOpenSmall.dae");
        modelSceneNodeOpen = modelSceneOpen?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeOpen?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNodeOpen?.position.x = -1
        modelSceneNodeOpen?.position.y = -1
        modelSceneNodeOpen?.position.z = -3
        modelSceneNodeOpen?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNodeOpen!);
        
        // Create 3D text
        let text = SCNText(string: "Samsonite IBON", extrusionDepth: 2);
        text.font = UIFont(name: "Helvetica", size: 10)
        let bodyText = SCNText(string: "De IBON collectie, gelanceerd in 2021, is een pionier \n op het gebied van innovatie en design. De opening bevindt \n zich aan de voorkant van de koffer, waardoor de oppervlakte \n die de valies inneemt hetzelfde blijft wanneer deze geopend is. \n Alle spullen van de reiziger blijven veilig opgeborgen dankzij de \n eenpuntssluiting met geïntegreerd TSA-slot.", extrusionDepth: 1)
        bodyText.font = UIFont(name: "Helvetica", size: 10)
        
        // Intro
        // Create & Add color
        let material = SCNMaterial();
        material.diffuse.contents = UIColor.red;
        text.materials = [material];
        // Creates node object & positions it
        node.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        node.position.z = -3
        node.position.y = +1
        node.geometry = text;
        node.isHidden = true
        
        let materialWhite = SCNMaterial();
        materialWhite.diffuse.contents = UIColor.white;
        bodyText.materials = [materialWhite]
        nodeBodyText.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01);
        nodeBodyText.position.y = +0.3;
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
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Swiping(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Swiping(_:)))

        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        sceneView.addGestureRecognizer(leftSwipe)
        sceneView.addGestureRecognizer(rightSwipe)
        
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
    
    
    @IBAction func sliderScale(_ sender: UISlider) {
        sender.minimumValue = 0.001
        sender.maximumValue = 0.021
        modelSceneNode?.scale = SCNVector3(sender.value, sender.value, sender.value);
        modelSceneNodeOpen?.scale = SCNVector3(sender.value, sender.value, sender.value);
    }
    
    
    @IBAction func SliderRotation(_ sender: UISlider) {
        sender.minimumValue = 0
        sender.maximumValue = 6.2
        modelSceneNode?.eulerAngles = SCNVector3(x: 1.5, y: sender.value, z: 0)
        modelSceneNodeOpen?.eulerAngles = SCNVector3(x: 1.5, y: sender.value, z: 0)
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
    
    @IBAction func ChangeColor(_ sender: UIButton) {
        modelSceneNode?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.systemPink
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.systemPink
    }
    
    
    @IBAction func ChangeColorRed(_ sender: UIButton) {
        modelSceneNode?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.red
    }
    
    @IBAction func ChangeColorGrey(_ sender: UIButton) {
        modelSceneNode?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.gray
    }
    
    @IBAction func ChangeColorGreen(_ sender: UIButton) {
        modelSceneNode?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.green
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.green
    }
    
    
    @IBAction func ChangeColorYellow(_ sender: UIButton) {
        modelSceneNode?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
    }
    
    
    @IBAction func ChangeColorWhite(_ sender: UIButton) {
        modelSceneNode?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.white
        modelSceneNodeOpen?.childNodes[21].childNodes[8].childNodes[2].geometry?.firstMaterial?.diffuse.contents = UIColor.white
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        print(location.x, location.y)

        let results = self.sceneView.hitTest(CGPoint(x: 0,y: 0), options: [SCNHitTestOption.rootNode: modelSceneNode!])
        
        let resultsOpen = self.sceneView.hitTest(CGPoint(x: 0,y: 0), options: [SCNHitTestOption.rootNode: modelSceneNodeOpen!])
        if modelSceneNode?.isHidden == false {
            if !results.isEmpty || !resultsOpen.isEmpty {
                // Closed Case
                if results[0].node.name != "CaseLeft" || results[0].node.name != "CaseRight" {
                    print("je klikt op de case")
                }
                
                if results[0].node.name != "Lock" {
                    modelSceneNode?.isHidden = true
                    modelSceneNodeOpen?.isHidden = false
                }
                
                let nameArrs = ["HandleMiddleLeft", "HandleMiddleRight", "HandleTopLeft", "HandleTopRight", "ExtendHandle"]
                
                for nameArr in nameArrs {
                    if results[0].node.name == nameArr {
                        print(nameArr)
                    }
                }
            } else {
                print("je klikt op de zever")
            }
        } else if modelSceneNodeOpen?.isHidden == false {
            if !resultsOpen.isEmpty {
                // Open Case
                
                if resultsOpen[0].node.name != "CaseLeft" || resultsOpen[0].node.name != "CaseRight" {
                    print("je klikt op de case")
                }
                
                if resultsOpen[0].node.name != "Lock" {
                    modelSceneNode?.isHidden = false
                    modelSceneNodeOpen?.isHidden = true
                }
                
                let nameArrs = ["HandleMiddleLeft", "HandleMiddleRight", "HandleTopLeft", "HandleTopRight", "ExtendHandle"]
                
                for nameArr in nameArrs {
                    if resultsOpen[0].node.name == nameArr {
                        print(nameArr)
                    }
                }
            } else {
                print("je klikt op de zever")
            }
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    
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
