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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostSession.delegate = self
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        initLabel = UILabel(frame:CGRect(x:0, y:0, width: sceneView.frame.width, height: 50))
        initLabel.textColor = UIColor.white
        initLabel.font = initLabel.font.withSize(25)
        initLabel.text = "Hold down to paint!"
        initLabel.center = CGPoint(x: sceneView.frame.midX, y: (sceneView.frame.midY)+250)
        initLabel.textAlignment = .center
        
        didInit = false
        anchorImage = UIImage(named: "art.scnassets/refrenceImage.png")
     
        
        imageView = UIImageView(image: anchorImage!)
        imageView.contentMode = .scaleAspectFit
        imageView.isOpaque = true
        imageView.frame = UIScreen.main.bounds
        imageView.contentMode = .scaleAspectFit
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.addSubview(initLabel)
        sceneView.addSubview(imageView)
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
        }
        
         let sphere1 = SCNSphere(radius: 0.01)
         sphere1.materials.first?.diffuse.contents = UIColor.blue
        
         let sphereNode1 = SCNNode(geometry: sphere1)
         sphereNode1.position = SCNVector3(0,0,0.1)
        
        let sphere2 = SCNSphere(radius: 0.01)
        sphere2.materials.first?.diffuse.contents = UIColor.green
        let sphereNode2 = SCNNode(geometry: sphere2)
        sphereNode2.position = SCNVector3(0,0.1,0)
        
     
        let sphere3 = SCNSphere(radius: 0.01)
        sphere3.materials.first?.diffuse.contents = UIColor.red
        let sphereNode3 = SCNNode(geometry: sphere3)
        sphereNode3.position = SCNVector3(0.1,0,0)
        
        
        sceneView.scene.rootNode.addChildNode(sphereNode1)
        sceneView.scene.rootNode.addChildNode(sphereNode2)
        sceneView.scene.rootNode.addChildNode(sphereNode3)
        
        
    }
    
    
    //update EACH frame
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        
        
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
