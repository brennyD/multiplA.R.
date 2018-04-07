//
//  SessionManager.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit



protocol SessionViewDelegate {
    
    func connectedDevicesChanged(manager : SessionManager, connectedDevices: [String])
   // func colorChanged(manager : SessionManager, colorString: String)
    
}



class SessionManager: NSObject{
    
    private let sessionID = "art-session"
    private let hostID: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    var session : MCSession
    var delegate: SessionViewDelegate?
    
    
     init(sessionTitle: String){
        self.hostID = MCPeerID(displayName: sessionTitle)
       // self.session = MCSession(peer: self.hostID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.optional)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.hostID, discoveryInfo: nil, serviceType: sessionID)
        self.session = MCSession(peer: self.hostID, securityIdentity: nil, encryptionPreference: .none)
        super.init()

        self.advertiser.delegate = self
        
        self.advertiser.startAdvertisingPeer()
        
        
    }
    
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
    }
    
    

}

extension SessionManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        
        
        invitationHandler(true, self.session)
      

        
        
    }

    
    
}

extension SessionManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
        session.connectedPeers.map{$0.displayName})
        
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void){
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
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
    
}



