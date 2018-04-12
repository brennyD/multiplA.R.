//
//  HostARViewController.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity


class HostARViewController: UIViewController, ARSCNViewDelegate, ARSessionObserver, SessionViewDelegate{
    
    
   
    

    

    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    @IBOutlet var initLabel: UILabel!
    
    var anchorImage: UIImage!
    
    var hostSession: SessionManager!
    
    var didInit: Bool!
    
    var imageView: UIImageView!
    
    var sessionStart: Bool!
    
    var cameraTrack: SCNNode!
    
    var dotAnchor: ARAnchor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostSession.delegate = self
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene()
        
        initLabel = UILabel(frame:CGRect(x:0, y:0, width: sceneView.frame.width, height: 50))
        initLabel.textColor = UIColor.white
        initLabel.font = initLabel.font.withSize(25)
        initLabel.center = CGPoint(x: sceneView.frame.midX, y: (sceneView.frame.midY)+250)
        initLabel.textAlignment = .center
        
        sessionStart = false
        didInit = false
        anchorImage = UIImage(named: "art.scnassets/refrenceImage.png")
     
        
        let sphere = SCNSphere(radius: 0.01)
        sphere.materials.first?.diffuse.contents = UIColor.white
        cameraTrack = SCNNode(geometry: sphere)
        cameraTrack.position = SCNVector3(0.0,0.0,0.0)
        
        
        dotAnchor = ARAnchor(transform: cameraTrack.simdWorldTransform)
        
        sceneView.session.add(anchor: dotAnchor)
        imageView = UIImageView(image: anchorImage!)
        imageView.contentMode = .scaleAspectFit
        imageView.isOpaque = true
        imageView.frame = UIScreen.main.bounds
        imageView.contentMode = .scaleAspectFit
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.addSubview(initLabel)
        sceneView.addSubview(imageView)
        sceneView.scene.rootNode.addChildNode(cameraTrack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.worldAlignment = .gravity
        
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
    
    
    func connectedDevicesChanged(manager: SessionManager, connectedDevices: [String]) {
        
    }
    
    func labelUpdated(manager: SessionManager, messageString: String) {
        return
    }
    
    func setOrigin(maanager: SessionManager) {
        
        sceneView.session.setWorldOrigin(relativeTransform: (sceneView.session.currentFrame?.camera.transform)!)
        OperationQueue.main.addOperation {
            self.imageView.removeFromSuperview()
            self.initLabel.text = "Now Tracking \(self.hostSession.showPeers().first?.displayName ?? "Client")"
        }
       
        sessionStart = true
        
    }
    
    
    func receivePos(manager: SessionManager, newPos: SCNVector3) {
        
        cameraTrack.position = SCNVector3(newPos.z, newPos.x, newPos.y)
        sceneView.session.remove(anchor: dotAnchor)
        dotAnchor = ARAnchor(transform: cameraTrack.simdWorldTransform)
        sceneView.session.add(anchor: dotAnchor)
        
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {

        
        
    }
    
    //updates EACH frame, sends current position to client
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval){
        if sessionStart == true{
            let pos = SCNVector3((sceneView.session.currentFrame?.camera.transform.columns.3.x)!, (sceneView.session.currentFrame?.camera.transform.columns.3.y)!, (sceneView.session.currentFrame?.camera.transform.columns.3.z)!)
            print("SENT")
            hostSession.sendCoordinate(position: pos)
        }
        
    }
    
    
    
    func session(_ session: ARSession,cameraDidChangeTrackingState camera: ARCamera){
        
        if didInit == false {
            didInit = true
            
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
