//
//  ClientManager.swift
//  ARt
//
//  Created by Samuel Lam on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SceneKit

protocol ClientManagerDelegate {
    
    func connectedDevicesChanged(manager : ClientManager, connectedDevices: [String])
    
    func transitionToSession(manager: ClientManager)
    
    func receivePos(manager: ClientManager, newPos: SCNVector3)
    
    func paintDump(manager: ClientManager, newPos: SCNVector3)
    
    //func colorChanged(manager : ClientManagerDelegate, colorString: String)
    
}

class ClientManager : NSObject {
    
    private let sessionID = "art-session"
    private let userID: MCPeerID
    private let serviceBrowser : MCNearbyServiceBrowser
    private var otherPaint: Bool
    lazy var session : MCSession = {
        let session = MCSession(peer: self.userID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
    }()
     var delegate : ClientManagerDelegate?
    
    init(username: String) {
        self.userID = MCPeerID(displayName: username)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.userID, serviceType: sessionID)
       self.otherPaint = false
        super.init()

        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    
    func send(message : String) {
        NSLog("%@", "sendColor: \(message) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }

    
    func showPeers() -> [MCPeerID] {
        return self.session.connectedPeers
    }
    
    
    
    func togglePaint(state: Bool){
        print("Sending Paint toggle")
        
        let message: String!
        
        if state{
            message = "true"
        }
        else{
            message = "false"
        }
        
        
        do {
            try self.session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let error {
            NSLog("%@", "Error for sending: \(error)")
        }
    }
    
    func sendCoordinate(position: SCNVector3){
        print("Sending Coordinate \(position)")
        if session.connectedPeers.count > 0 {
            do {
                
                let packet = NSKeyedArchiver.archivedData(withRootObject: position)
                
                /*var temp = "\(coor)"
                 temp.remove(at: String.Index)
                 print(temp)*/
                
                try self.session.send( packet, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    
}

extension ClientManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        browser.stopBrowsingForPeers()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}







extension ClientManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
  
         if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as! SCNVector3?{
            if otherPaint{
                self.delegate?.paintDump(manager: self, newPos: dict)
            }
                
            else{
                self.delegate?.receivePos(manager: self, newPos: dict)
            }
        }
        
       else if let inbox = String(data: data, encoding: .utf8) as String?{
            
            
            if inbox == "false"{
                self.otherPaint = false
                print("Paint toggled to false")
            }
            if inbox == "true"{
                self.otherPaint = true
                print("Paint toggled to false")
            }
            
            
            
            if inbox == "SET TO AR SESSION" {
                self.delegate?.transitionToSession(manager: self)
            }
        } 

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    
}
