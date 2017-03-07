//
//  MultiPeerManager.swift
//  pongball
//
//  Created by Samuel Honorato on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MultipeerDelegate {
    func peerConnected(peer: String, withDisplayName displayName: String)
    func peerDisconnected(peer: String)
    func peerSentMessage(peer: String, message: String)
}

extension MultipeerDelegate {
    func peerConnected(peer: String, withDisplayName displayName: String) { }
    func peerDisconnected(peer: String) { }
    func peerSentMessage(peer: String, message: String) { }
}

class MultipeerManager: NSObject {
        
    var delegate: MultipeerDelegate?
    
    var peer = MCPeerID.init(displayName: UIDevice.current.name)
    
    let serviceTypePadrao = "pong2"
    
    var browser: MCNearbyServiceBrowser
    
    var peers: [MCPeerID:String] = [:]
    
    override init() {
        
        
        
        browser = MCNearbyServiceBrowser.init(peer: peer, serviceType: serviceTypePadrao)
        
        
        super.init()
        
        browser.delegate = self
        browser.startBrowsingForPeers()
        

    }
    
    lazy var session: MCSession = {
        let sessao = MCSession.init(peer: self.peer)
        sessao.delegate = self
        return sessao
    }()
    
}

extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if let nome = info?["key"] {
            peers.updateValue(nome, forKey: peerID)
        }
        
        self.browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) { }
}


extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String

        // RECEIVED MESSAGE FROM PEER
        print("------------------")
        print("\(peers[peerID]!):\(message)")
        
        DispatchQueue.main.async {
            self.delegate?.peerSentMessage(peer: self.peers[peerID]!, message: message)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            
            // PEER CONNECTED
            delegate?.peerConnected(peer: peers[peerID]!, withDisplayName: peerID.displayName)
            
            do {

                try session.send("red".data(using: .utf8, allowLossyConversion: false)!, toPeers: [peerID], with: .reliable)

            } catch _ {

            }
            
            
        case .connecting:
            // PEER IS CONNECTING
            break
        case .notConnected:
            
            // PEER DISCONNECTED
            
            delegate?.peerDisconnected(peer: peers[peerID]!)
            peers.removeValue(forKey: peerID)
        }
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) { }
    
}
