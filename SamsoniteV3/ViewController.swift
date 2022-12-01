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
    
    var modelSceneOpen: SCNScene?
    var modelSceneNodeOpen: SCNNode?
    
    var modelSceneHP: SCNScene?
    var modelSceneNodeHP: SCNNode?
    
    var modelSceneOpenHP: SCNScene?
    var modelSceneNodeOpenHP: SCNNode?
    
    var modelSceneRed: SCNScene?
    var modelSceneNodeRed: SCNNode?
    
    var modelSceneOpenRed: SCNScene?
    var modelSceneNodeOpenRed: SCNNode?
    
    var counter: Double = 0.01;
    var rotateX: Float = 1.5
    var rotateY: Float = 0
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
        modelScene = SCNScene(named: "IbonClosed.dae");
        modelSceneNode = modelScene?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNode?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNode?.position.x = -1
        modelSceneNode?.position.y = -1

        scene.rootNode.addChildNode(modelSceneNode!);

        modelSceneOpen = SCNScene(named: "IbonOpen.dae");
        modelSceneNodeOpen = modelSceneOpen?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeOpen?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNodeOpen?.position.x = -1
        modelSceneNodeOpen?.position.y = -1
        modelSceneNodeOpen?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNodeOpen!);

        // Loading in different colors
        modelSceneHP = SCNScene(named: "IbonClosedHotPink.dae");
        modelSceneNodeHP = modelSceneHP?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeHP?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNodeHP?.position.x = -1
        modelSceneNodeHP?.position.y = -1
        modelSceneNodeHP?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNodeHP!);

        modelSceneOpenHP = SCNScene(named: "IbonOpenHotPink.dae");
        modelSceneNodeOpenHP = modelSceneOpenHP?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeOpenHP?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNodeOpenHP?.position.x = -1
        modelSceneNodeOpenHP?.position.y = -1
        modelSceneNodeOpenHP?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNodeOpenHP!);
        
        modelSceneRed = SCNScene(named: "IbonClosedRed.dae");
        modelSceneNodeRed = modelSceneRed?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeRed?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNodeRed?.position.x = -1
        modelSceneNodeRed?.position.y = -1
        modelSceneNodeRed?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNodeRed!);

        modelSceneOpenRed = SCNScene(named: "IbonOpenRed.dae");
        modelSceneNodeOpenRed = modelSceneOpenRed?.rootNode.childNode(withName: "IBON", recursively: true)
        modelSceneNodeOpenRed?.eulerAngles = SCNVector3(x: rotateX, y: rotateY, z: rotateZ)
        modelSceneNodeOpenRed?.position.x = -1
        modelSceneNodeOpenRed?.position.y = -1
        modelSceneNodeOpenRed?.isHidden = true

        scene.rootNode.addChildNode(modelSceneNodeOpenRed!);
        
        // Create 3D text
        let text = SCNText(string: "Samsonite IBON", extrusionDepth: 2);
        let bodyText = SCNText(string: "De IBON collectie, gelanceerd in 2021, is een pionier \n op het gebied van innovatie en design. De opening bevindt \n zich aan de voorkant van de koffer, waardoor de oppervlakte \n die de valies inneemt hetzelfde blijft wanneer deze geopend is. \n Alle spullen van de reiziger blijven veilig opgeborgen dankzij de \n eenpuntssluiting met geïntegreerd TSA-slot.", extrusionDepth: 1)
        
        // Intro
        // Create & Add color
        let material = SCNMaterial();
        material.diffuse.contents = UIColor.red;
        material.diffuse.contents = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.black)
        text.materials = [material];
        // Creates node object & positions it
        node.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        node.geometry = text;
        
        let materialWhite = SCNMaterial();
        materialWhite.diffuse.contents = UIColor.white;
        material.diffuse.contents = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        bodyText.materials = [materialWhite]
        nodeBodyText.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01);
        nodeBodyText.position.y = -1;
        nodeBodyText.geometry = bodyText;
        
        // Part 1
        let titleInstr = SCNText(string: "Instructions", extrusionDepth: 2);
        titleInstr.materials = [material];
        nodeInstr.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        nodeInstr.position.y = -50;
        nodeInstr.geometry = titleInstr;
        
        let bodyInstrText = SCNText(string: "Swipe right for next text \n Swipe left for previous text \n Move slider to see the real life size \n Tap to change the colors \n Click on the lock to open it \n Experiment and enjoy!", extrusionDepth: 1)
        bodyInstrText.materials = [materialWhite]
        nodeInstrText.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01);
        nodeInstrText.position.y = -51;
        nodeInstrText.geometry = bodyInstrText;
        
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
    
    
    @IBAction func sliderScale(_ sender: UISlider) {
        sender.minimumValue = 0.001
        sender.maximumValue = 0.021
        print(sender.value)
        modelSceneNode?.scale = SCNVector3(sender.value, sender.value, sender.value);
        modelSceneNodeOpen?.scale = SCNVector3(sender.value, sender.value, sender.value);
        modelSceneNodeHP?.scale = SCNVector3(sender.value, sender.value, sender.value);
        modelSceneNodeOpenHP?.scale = SCNVector3(sender.value, sender.value, sender.value);
    }
    
    
    @IBAction func SliderRotation(_ sender: UISlider) {
        sender.minimumValue = 0
        sender.maximumValue = 6.2
        print(sender.value)
        modelSceneNode?.eulerAngles = SCNVector3(x: 0, y: sender.value, z: 0)
        modelSceneNodeOpen?.eulerAngles = SCNVector3(x: 0, y: sender.value, z: 0)
        modelSceneNodeHP?.eulerAngles = SCNVector3(x: 0, y: sender.value, z: 0)
        modelSceneNodeOpenHP?.eulerAngles = SCNVector3(x: 0, y: sender.value, z: 0)
    }
    
    @IBAction func Swiping(_ sender: UISwipeGestureRecognizer) {
        let arrNodes = [node, nodeBodyText, nodeInstr, nodeInstrText];
        
        switch sender.direction{
            case .left:
                for arrNode in arrNodes {
                    arrNode.position.y = arrNode.position.y - 50
                }
            case .right:
                for arrNode in arrNodes {
                    arrNode.position.y = arrNode.position.y + 50
                }
            default://default
                print("default")
            }
    }
    
    @IBAction func OpenCase(_ sender: UITapGestureRecognizer) {
        if modelSceneNode?.isHidden == true && modelSceneNodeOpen?.isHidden == false {
            modelSceneNode?.isHidden = false
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeRed?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = true
        } else if modelSceneNodeHP?.isHidden == true && modelSceneNodeOpenHP?.isHidden == false {
            modelSceneNode?.isHidden = true
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeHP?.isHidden = false
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeRed?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = true
        } else if modelSceneNodeHP?.isHidden == false && modelSceneNodeOpenHP?.isHidden == true {
            modelSceneNode?.isHidden = true
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = false
            modelSceneNodeRed?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = true
        } else if modelSceneNodeRed?.isHidden == true && modelSceneNodeOpenRed?.isHidden == false {
            modelSceneNode?.isHidden = true
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeRed?.isHidden = false
            modelSceneNodeOpenRed?.isHidden = true
        } else if modelSceneNodeRed?.isHidden == false && modelSceneNodeOpenRed?.isHidden == true {
            modelSceneNode?.isHidden = true
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeRed?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = false
        } else {
            modelSceneNode?.isHidden = true
            modelSceneNodeOpen?.isHidden = false
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeRed?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = true
        }
    }
    
    
    @IBAction func ChangeColor(_ sender: UIButton) {
        if modelSceneNode?.isHidden == false || modelSceneNodeRed?.isHidden == false {
            modelSceneNode?.isHidden = true
            modelSceneNodeHP?.isHidden = false
            modelSceneNodeRed?.isHidden = true
        } else if modelSceneNodeOpen?.isHidden == false || modelSceneNodeOpenRed?.isHidden == false {
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = false
            modelSceneNodeOpenRed?.isHidden = true
        }
    }
    
    
    @IBAction func ChangeColorRed(_ sender: UIButton) {
        if modelSceneNode?.isHidden == false || modelSceneNodeHP?.isHidden == false {
            modelSceneNode?.isHidden = true
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeRed?.isHidden = false
        } else if modelSceneNodeOpen?.isHidden == false || modelSceneNodeOpenHP?.isHidden == false {
            modelSceneNodeOpen?.isHidden = true
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = false
        }
    }
    
    @IBAction func ChangeColorGrey(_ sender: UIButton) {
        if modelSceneNodeRed?.isHidden == false || modelSceneNodeHP?.isHidden == false {
            modelSceneNode?.isHidden = false
            modelSceneNodeHP?.isHidden = true
            modelSceneNodeRed?.isHidden = true
        } else if modelSceneNodeOpenRed?.isHidden == false || modelSceneNodeOpenHP?.isHidden == false {
            modelSceneNodeOpen?.isHidden = false
            modelSceneNodeOpenHP?.isHidden = true
            modelSceneNodeOpenRed?.isHidden = true
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
