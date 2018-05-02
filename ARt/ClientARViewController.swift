//
//  ClientARViewController.swift
//  ARt
//
//  Created by Samuel Lam on 4/7/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import ARKit
import MultipeerConnectivity

class ClientARViewController: UIViewController, ARSCNViewDelegate, ARSessionObserver, ClientManagerDelegate{
 
    
   
    
    
    @IBOutlet var sceneView: ARSCNView!
    @IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    @IBOutlet var initLabel: UILabel!
    var clientSession: ClientManager!
    
    var didInit: Bool!
    var sessionStart: Bool!
    
    
    var isPressed: UITapGestureRecognizer!
    var painter: Bool!
    
    
    
    
    var cameraTrack: SCNNode!
    
    var dotAnchor: ARAnchor!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DATA RECEIVED \(clientSession.showPeers())")
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false

       // sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        let partnerSphere = SCNSphere(radius: 0.01)
        partnerSphere.materials.first?.diffuse.contents = UIColor.magenta
        
        cameraTrack = SCNNode(geometry: partnerSphere)
        cameraTrack.position = SCNVector3(0,0,0)
        
        
        
        
        painter = false
        dotAnchor = ARAnchor(transform: cameraTrack.simdWorldTransform)
        
        
        isPressed = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        sceneView.addGestureRecognizer(isPressed)
        
        
        
        
        clientSession.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        initLabel = UILabel(frame:CGRect(x:0, y:0, width: sceneView.frame.width, height: 50))
        initLabel.textColor = UIColor.white
        initLabel.font = initLabel.font.withSize(25)
        initLabel.text = "Move camera to initialize session"
        initLabel.center = CGPoint(x: sceneView.frame.midX, y: (sceneView.frame.midY)+250)
        initLabel.textAlignment = .center
        
        sessionStart = false
        didInit = false
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.addSubview(initLabel)
        sceneView.session.add(anchor: dotAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.worldAlignment = .gravity
        
        configuration.planeDetection = [.horizontal, .vertical]
        
        
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.detectionImages = referenceImages
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    //updates EACH frame, sends current position to Host
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if sessionStart{
            painter = !painter
            self.clientSession.togglePaint(state: painter)
        }
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval){
        if sessionStart == true{
            let pos = SCNVector3((sceneView.session.currentFrame?.camera.transform.columns.3.x)!, (sceneView.session.currentFrame?.camera.transform.columns.3.y)!, (sceneView.session.currentFrame?.camera.transform.columns.3.z)!)
            print("SENT")
            clientSession.sendCoordinate(position: pos)
 
            print(isPressed.state)
        
            
            if painter == true{
                
                let paint = SCNSphere(radius: 0.01)
                paint.materials.first?.diffuse.contents = UIColor.white
                let temp = SCNNode(geometry: paint)
                temp.position = SCNVector3((sceneView.session.currentFrame?.camera.transform.columns.3.x)!, (sceneView.session.currentFrame?.camera.transform.columns.3.y)!, (sceneView.session.currentFrame?.camera.transform.columns.3.z)!)
                sceneView.scene.rootNode.addChildNode(temp)
            }
            
            
            
            
        }
        
    }
    
    
    func connectedDevicesChanged(manager: ClientManager, connectedDevices: [String]) {
        return
    }
    
    func transitionToSession(manager: ClientManager) {
        return
    }
    
    //ADDED ANCHOR UPDATES ??
    func receivePos(manager: ClientManager, newPos :SCNVector3) {
        cameraTrack.position = SCNVector3(newPos.y, newPos.z, newPos.x)
        
        
        /*sceneView.session.remove(anchor: dotAnchor)
        dotAnchor = ARAnchor(transform: cameraTrack.simdWorldTransform)
        sceneView.session.add(anchor: dotAnchor)*/
        
    }
    
    func paintDump(manager: ClientManager, newPos: SCNVector3) {
        let paint = SCNSphere(radius: 0.01)
        paint.materials.first?.diffuse.contents = UIColor.white
        let temp = SCNNode(geometry: paint)
        temp.position = SCNVector3(newPos.y, newPos.z, newPos.x)
        sceneView.scene.rootNode.addChildNode(temp)
    }
    

    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        
        
    }
    
    
    
    //handles pressed event
    @IBAction
    func paintPress(sender: UILongPressGestureRecognizer){
        
    }
    
    
    //Anchor of any kind is added
    func renderer(_ renderer: SCNSceneRenderer,didAdd node: SCNNode, for anchor: ARAnchor){
        
        
        if didInit == false{
            guard let tempAnch = anchor as? ARPlaneAnchor else {return}
            
            didInit = true
            
            OperationQueue.main.addOperation {
                self.initLabel.text = "Point to the image!"
            }
        }
        else{
        guard let image = anchor as? ARImageAnchor else {return}
        
        sceneView.session.setWorldOrigin(relativeTransform: image.transform)
        sceneView.scene.rootNode.addChildNode(cameraTrack)
        
        OperationQueue.main.addOperation {
            self.initLabel.text = "Now Tracking \(self.clientSession.showPeers().first?.displayName ?? "Host")"
        }
        
        
        clientSession.send(message: "SET")
        sessionStart = true
        }
        
    }
    
    
    func session(_ session: ARSession,cameraDidChangeTrackingState camera: ARCamera){
        
        
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

