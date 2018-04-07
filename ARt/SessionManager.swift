//
//  SessionManager.swift
//  ARt
//
//  Created by Brendan DeMilt on 4/6/18.
//  Copyright © 2018 Multiplaugmented Mentalities. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class SessionManager: NSObject{
    
    private let sessionID = "art-session"
    private let hostID: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    
     init(sessionTitle: String){
        self.hostID = MCPeerID(displayName: sessionTitle)
        self.advertiser = MCNearbyServiceAdvertiser(peer: hostID, discoveryInfo: nil, serviceType: sessionID)
        
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
    }
    
}
