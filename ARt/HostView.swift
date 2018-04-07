//
//  HostView.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity




class HostView: UIViewController{
    
    
  
    @IBOutlet var label: UILabel!
    
    
    var sessionName: String!
    var hostSession: SessionManager!
    

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let sessionInput = UIAlertController(title: "Input session name", message: nil, preferredStyle: .alert)
        
        sessionInput.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sessionInput.addTextField(configurationHandler: {textField in textField.placeholder = ""})
        sessionInput.addAction(UIAlertAction(title: "Enter", style: .default, handler: {action in
            
            if sessionInput.textFields?.first?.text != "" {
                self.sessionName = sessionInput.textFields?.first?.text
                self.hostSession = SessionManager(sessionTitle: self.sessionName)
                self.hostSession.delegate = self
            }
    
        }))
        
        
        self.present(sessionInput, animated: true)
        
    }
    
    
    func updateTable() -> Void {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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

    
    
    func updateLabel(newText: String){
        self.label.text = newText
    }
    
    
    
}

extension HostView: SessionViewDelegate{
    func labelUpdated(manager: SessionManager, messageString: String) {
        self.updateLabel(newText: messageString)
        
         NSLog("%@", "Data received: \(messageString)")
        
        
    }
    
    func connectedDevicesChanged(manager: SessionManager, connectedDevices: [String]) {
        print("Connection: \(connectedDevices)")
        self.updateLabel(newText: "Connected")
    }
    
    
    
    
    
    
    
}





