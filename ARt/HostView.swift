//
//  HostView.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import UIKit


class HostView: UIViewController{
    
    
    @IBOutlet weak var ClientTable: UITableView!

    var sessionName: String!
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let nameInput = UIAlertController(title: "Input session name", message: nil, preferredStyle: .alert)
        
        nameInput.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        nameInput.addTextField(configurationHandler: {textField in textField.placeholder = ""})
        nameInput.addAction(UIAlertAction(title: "Enter", style: .default, handler: {action in
            
            if nameInput.textFields?.first?.text != "" {
                self.sessionName = nameInput.textFields?.first?.text
            } else {
                self.present(nameInput, animated: true)
            }
        } ))
        
        
        self.present(nameInput, animated: true)
      
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
 
    
    
    
    
}
