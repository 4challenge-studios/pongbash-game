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
    func peerConnected(peer: MCPeerID)
    func peerDisconnected(peer: MCPeerID)
}

class MultipeerManager: NSObject {
        
    var delegate: MultipeerDelegate?
    
    var peer = MCPeerID.init(displayName: UIDevice.current.name)
    
    let serviceTypePadrao = "pong2"
    
    var browser: MCNearbyServiceBrowser
    
    var onlines: [MCPeerID:String] = [:]
    
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
            print("CHAVE: \(nome)")
        }
        
        self.browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) { }
}


extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        //let mensagem: String = NSKeyedUnarchiver.unarchiveObject(with: data) as! String
        
        let mensagem = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            print("\(peerID.displayName): \(mensagem)")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            print("Conectou \(peerID.displayName)")
            delegate?.peerConnected(peer: peerID)
        case .connecting:
            print("Conectando \(peerID.displayName)")
        case .notConnected:
            print("Desconectou \(peerID.displayName)")
            delegate?.peerDisconnected(peer: peerID)
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
