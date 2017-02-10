//
//  ControllerManager.swift
//  pongball
//
//  Created by Matheus Martins on 2/10/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum ControllerButton {
    case Left
    case Right
    case Kick
}

protocol ControllerDelegate {
    func didPress(button: ControllerButton)
    func didRelease(button: ControllerButton)
}

extension ControllerDelegate {
    func didPress(button: ControllerButton) {}
    func didRelease(button: ControllerButton) {}
}

class Controller {
    var id: String = ""
    
    var delegate: ControllerDelegate?
}

class ControllerManager: MultipeerDelegate {
    
    var controllers: [String:Controller] = [:]
    
    
    func peerConnected(peer: MCPeerID) {
        let controller = Controller()
        
        controllers.updateValue(controller, forKey: peer.displayName)
    }
    
    func peerDisconnected(peer: MCPeerID) {
        
    }
}
