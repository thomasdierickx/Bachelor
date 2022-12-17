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
    var modelTextNode: SCNNode = SCNNode();
    
    var configuration = ARWorldTrackingConfiguration()
    var configImg = ARImageTrackingConfiguration()
    
    var configChoise = false
    
    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showAdded(to: self.sceneView, animated: true);
        self.hud.label.text = "Loading assets"
        self.hud.detailsLabel.text = "Welcome to the Samsonite AR application! Use me \n to scan the catalogus and look for hidden features!"
        self.hud.hide(animated: true, afterDelay: 3)
        
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
        
        modelTextNode = modelGlobal.rootNode.childNode(withName: "Intro", recursively: true)!
        modelTextNode.isHidden = true
        
        scene.rootNode.addChildNode(modelRoomNode)
        scene.rootNode.addChildNode(modelCarNode)
        scene.rootNode.addChildNode(modelTextNode)
  
        let carText = SCNText(string: "Do i fit in here?", extrusionDepth: 2)
        carText.font = UIFont(name: "Helvetica", size: 10)
        
        // Intro
        // Create & Add color
        let material = SCNMaterial();
        material.diffuse.contents = UIColor.red;
        carText.materials = [material]
        
        nodeCarText.scale = SCNVector3(x: 0.04, y: 0.04, z: 0.04);
        nodeCarText.position = SCNVector3(x: -9, y: 1.5, z: -1.5)
        nodeCarText.eulerAngles = SCNVector3(0, 2.0, 0)
        nodeCarText.geometry = carText;
        nodeCarText.isHidden = true
        
        // Set the scene & elements to the view
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true; // Adds lighting and shadows
        sceneView.scene.rootNode.addChildNode(nodeCarText)
        
        // Add pan gesture for dragging the textNode about
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
        if anchor is ARPlaneAnchor {
            DispatchQueue.main.async {
                self.hud.label.text = "Plane Detected"
                self.hud.hide(animated: true, afterDelay: 1.0)
            }
            if configChoise == true {
                onlyLoadWhenLoaded()
            } else {
                print("not yet")
            }
        }
        
        // Cover video
        guard let imageAnchor = anchor as? ARImageAnchor, let fileUrlString = Bundle.main.path(forResource: "IbonVideoV2", ofType: "mp4") else {return}
        guard let imageAnchor2 = anchor as? ARImageAnchor, let fileUrlString2 = Bundle.main.path(forResource: "Lock", ofType: "mp4") else {return}
        guard let imageAnchor3 = anchor as? ARImageAnchor, let fileUrlString3 = Bundle.main.path(forResource: "Comp", ofType: "mp4") else {return}

        //find our video file
        let videoItem = AVPlayerItem(url: URL(fileURLWithPath: fileUrlString))
        let player = AVPlayer(playerItem: videoItem)
        let videoItem2 = AVPlayerItem(url: URL(fileURLWithPath: fileUrlString2))
        let player2 = AVPlayer(playerItem: videoItem2)
        let videoItem3 = AVPlayerItem(url: URL(fileURLWithPath: fileUrlString3))
        let player3 = AVPlayer(playerItem: videoItem3)
        
        //initialize video node with avplayer
        let videoNode = SKVideoNode(avPlayer: player)
        player.play()
        let videoNode2 = SKVideoNode(avPlayer: player2)
        player2.play()
        let videoNode3 = SKVideoNode(avPlayer: player3)
        player3.play()
        
        // add observer when our player.currentItem finishes player, then start playing from the beginning
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (notification) in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player2.currentItem, queue: nil) { (notification) in
            player2.seek(to: CMTime.zero)
            player2.play()
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player3.currentItem, queue: nil) { (notification) in
            player3.seek(to: CMTime.zero)
            player3.play()
        }
                
        // set the size (just a rough one will do)
        let videoScene = SKScene(size: CGSize(width: 3266, height: 3888))
        let videoScene2 = SKScene(size: CGSize(width: 1000, height: 1000))
        let videoScene3 = SKScene(size: CGSize(width: 1000, height: 1000))

        // center our video to the size of our video scene
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode2.position = CGPoint(x: videoScene2.size.width / 2, y: videoScene2.size.height / 2)
        videoNode3.position = CGPoint(x: videoScene3.size.width / 2, y: videoScene3.size.height / 2)

        // invert our video so it does not look upside down
        videoNode.yScale = -1.0
        videoNode2.yScale = -1.0
        videoNode3.yScale = -1.0

        // add the video to our scene
        videoScene.addChild(videoNode)
        videoScene2.addChild(videoNode2)
        videoScene3.addChild(videoNode3)
        
        // create a plan that has the same real world height and width as our detected image
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        let plane2 = SCNPlane(width: imageAnchor2.referenceImage.physicalSize.width, height: imageAnchor2.referenceImage.physicalSize.height)
        let plane3 = SCNPlane(width: imageAnchor3.referenceImage.physicalSize.width, height: imageAnchor3.referenceImage.physicalSize.height)

        // set the first materials content to be our video scene
        if imageAnchor.referenceImage.name == "ImgCoverV2" && imageAnchor2.referenceImage.name == "ImgCoverV2" && imageAnchor3.referenceImage.name == "ImgCoverV2" {
            plane.firstMaterial?.diffuse.contents = videoScene
        }
        if imageAnchor.referenceImage.name == "ImgLock" && imageAnchor2.referenceImage.name == "ImgLock" && imageAnchor3.referenceImage.name == "ImgLock" {
            plane2.firstMaterial?.diffuse.contents = videoScene2
        }
        if imageAnchor.referenceImage.name == "ImgZ" && imageAnchor2.referenceImage.name == "ImgZ" && imageAnchor3.referenceImage.name == "ImgZ" {
            plane3.firstMaterial?.diffuse.contents = videoScene3
        }

        // create a node out of the plane
        let planeNode = SCNNode(geometry: plane)
        let planeNode2 = SCNNode(geometry: plane2)
        let planeNode3 = SCNNode(geometry: plane3)

        // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
        planeNode.eulerAngles.x = -Float.pi / 2
        planeNode.position.y = +0.001
        planeNode2.eulerAngles.x = -Float.pi / 2
        planeNode3.eulerAngles.x = -Float.pi / 2

        // finally add the plane node (which contains the video node) to the added node
        node.addChildNode(planeNode)
        node.addChildNode(planeNode2)
        node.addChildNode(planeNode3)
    }
    
    func onlyLoadWhenLoaded() {
        
        modelSceneNode.isHidden = false
        modelRoomNode.isHidden = false
        modelCarNode.isHidden = false
        nodeCarText.isHidden = false
        modelTextNode.isHidden = false
        
    }
    
    func onlyHideWhenLoaded() {
        
        modelSceneNode.isHidden = true
        modelSceneNodeOpen.isHidden = true
        modelSceneNodeOpen.isHidden = true
        modelRoomNode.isHidden = true
        modelCarNode.isHidden = true
        nodeCarText.isHidden = true
        modelTextNode.isHidden = true
        
    }
    
    
    @IBAction func ChangeBool(_ sender: UIButton) {
        configChoise = !configChoise
        if configChoise == false {
            print(configChoise)
            viewWillAppear(true)
        } else {
            print(configChoise)
            viewWillAppear(true)
        }
        print(configChoise)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        configuration.planeDetection = .horizontal

        // Run the view's session

        if let trackedImgs = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) {
            configImg.trackingImages = trackedImgs
            configImg.maximumNumberOfTrackedImages = 1
        }

        if configChoise == false {
            onlyHideWhenLoaded()
            sceneView.session.run(configImg)
        } else {
            sceneView.session.run(configuration)
        }
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
            if modelSceneNode.isHidden == false {
                modelSceneNode.position = posRay
                modelSceneNodeOpen.position = posRay
                modelSceneNodeOpen.isHidden = true
            } else {
                modelSceneNode.position = posRay
                modelSceneNodeOpen.position = posRay
                modelSceneNode.isHidden = true
            }
        } else {
            print("resultsRay is empty")
        }
    }
    
    @IBAction func ResetScene(_ sender: UIButton) {
        sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        if configChoise == false {
            sceneView.session.run(configImg)
        } else {
            sceneView.session.run(configuration)
        }
        print(configChoise)
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
