//
//  ControllerManager.swift
//  pongball
//
//  Created by Matheus Martins on 2/10/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Controller {
    var id: String = ""
}

class ControllerManager: MultipeerDelegate {
    
    var controllers: [Controller] = []
    
    
    func peerConnected(peer: MCPeerID) {
        let controller = Controller()
        
        controllers.append(controller)
    }
    
    func peerDisconnected(peer: MCPeerID) {
        
    }
}
