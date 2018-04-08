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
    
    
    var cameraTrack: SCNNode!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DATA RECEIVED \(clientSession.showPeers())")
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false

        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        let partnerSphere = SCNSphere(radius: 0.01)
        partnerSphere.materials.first?.diffuse.contents = UIColor.white
        
        cameraTrack = SCNNode(geometry: partnerSphere)
        cameraTrack.position = SCNVector3(0,0,0)
        
        clientSession.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        initLabel = UILabel(frame:CGRect(x:0, y:0, width: sceneView.frame.width, height: 50))
        initLabel.textColor = UIColor.white
        initLabel.font = initLabel.font.withSize(25)
        initLabel.text = "Pan camera while scene builds"
        initLabel.center = CGPoint(x: sceneView.frame.midX, y: (sceneView.frame.midY)+250)
        initLabel.textAlignment = .center
        
        
        didInit = false
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.addSubview(initLabel)
        sceneView.scene.rootNode.addChildNode(cameraTrack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.worldAlignment = .gravity
        
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
    
    
    
    func connectedDevicesChanged(manager: ClientManager, connectedDevices: [String]) {
        return
    }
    
    func transitionToSession(manager: ClientManager) {
        return
    }
    
    func receivePos(manager: ClientManager, newPos :SCNVector3) {
        cameraTrack.position = SCNVector3(newPos.y, newPos.z, newPos.x)
        
    }
    

    
    //update EACH frame
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        
        
    }
    
    
    //Anchor of any kind is added
    func renderer(_ renderer: SCNSceneRenderer,didAdd node: SCNNode, for anchor: ARAnchor){
        
        guard let image = anchor as? ARImageAnchor else {return}
        
        sceneView.session.setWorldOrigin(relativeTransform: image.transform)
  
        clientSession.send(message: "SET")
        
        
    }
    
    
    func session(_ session: ARSession,cameraDidChangeTrackingState camera: ARCamera){
        
        if didInit == false {
            didInit = true
            initLabel.text = "Point to the image!"
        }
        
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

