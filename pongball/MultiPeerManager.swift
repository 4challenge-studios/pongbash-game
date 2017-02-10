//
//  MultiPeerManager.swift
//  pongball
//
//  Created by Samuel Honorato on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPeerManager: NSObject {
        
    //var delegate: MultiPeerDelegate?
    
    var peer = MCPeerID.init(displayName: UIDevice.current.name)
    var advertiser: MCNearbyServiceAdvertiser
    let serviceTypePadrao = "pong"
    
    
    var onlines: [MCPeerID:String] = [:]
    
    override init() {
        
        advertiser = MCNearbyServiceAdvertiser.init(peer: peer, discoveryInfo: nil, serviceType: serviceTypePadrao)
        
        
        super.init()
        
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

    }
    
    lazy var session: MCSession = {
        let sessao = MCSession.init(peer: self.peer)
        sessao.delegate = self
        return sessao
    }()
    
}

extension MultiPeerManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("recebi convite")
        
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) { }
}

extension MultiPeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        //let mensagem: String = NSKeyedUnarchiver.unarchiveObject(with: data) as! String
        
        let mensagem = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            print("\(peerID.displayName): \(mensagem)")
        
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            print("Conectou \(peerID.displayName)")
        case .connecting:
            print("Conectando \(peerID.displayName)")
        case .notConnected:
            print("Desconectou \(peerID.displayName)")
        }
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) { }
    
}
