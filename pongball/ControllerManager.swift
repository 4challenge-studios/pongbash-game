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
    func Controller(_ controller: Controller, didPressButton button: ControllerButton)
    func Controller(_ controller: Controller, didReleaseButton button: ControllerButton)
}

extension ControllerDelegate {
    func Controller(_ controller: Controller, didPressButton button: ControllerButton) {}
    func Controller(_ controller: Controller, didReleaseButton button: ControllerButton) {}
}

class Controller {
    var id: String = ""
    
    lazy var delegate: ControllerDelegate? = nil
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
