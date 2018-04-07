
//
//  File.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import UIKit


class ClientView: UIViewController{
    
    var username: String!
    var send: String!
    var clientSession: ClientManager!
    
    @IBAction func sendButton(_ sender: UIButton) {
        let nameInput = UIAlertController(title: "Input message to send", message: nil, preferredStyle: .alert)
        
        nameInput.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        nameInput.addTextField(configurationHandler: {textField in textField.placeholder = "" })
        nameInput.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            if nameInput.textFields?.first?.text != "" {
                self.send = nameInput.textFields?.first?.text
                self.clientSession.send(message: self.send)
            } else {
                self.present(nameInput, animated: true)
            }
        } ))
        
        self.present(nameInput, animated: true)
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nameInput = UIAlertController(title: "Input username", message: nil, preferredStyle: .alert)
        
        nameInput.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        nameInput.addTextField(configurationHandler: {textField in textField.placeholder = "" })
        nameInput.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            if nameInput.textFields?.first?.text != "" {
                self.username = nameInput.textFields?.first?.text
                self.clientSession = ClientManager(username: self.username)
                self.clientSession.delegate = self
            } else {
                self.present(nameInput, animated: true)
            }
        } ))
        
        self.present(nameInput, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ClientView : ClientManagerDelegate {
    
    func connectedDevicesChanged(manager: ClientManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
            print("Connections: \(connectedDevices)")
        }
    }
    
    //        func colorChanged(manager: ColorServiceManager, colorString: String) {
    //            OperationQueue.main.addOperation {
    //                switch colorString {
    //                case "red":
    //                    self.change(color: .red)
    //                case "yellow":
    //                    self.change(color: .yellow)
    //                default:
    //                    NSLog("%@", "Unknown color value received: \(colorString)")
    //                }
    //            }
    //        }
    
}

