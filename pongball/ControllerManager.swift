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
    case leftDown
    case leftUp
    case rightDown
    case rightUp
    case kick
}

protocol ControllerDelegate {
    func controller(_ controller: Controller, didPressButton button: ControllerButton)
    func controller(_ controller: Controller, didReleaseButton button: ControllerButton)
}

extension ControllerDelegate {
    func controller(_ controller: Controller, didPressButton button: ControllerButton) {}
    func controller(_ controller: Controller, didReleaseButton button: ControllerButton) {}
}

class Controller {
    var id: String = ""
    var displayName: String = ""
    
    var commands: [String:ControllerButton] = [
        "kick": .kick, "leftDown": .leftDown, "leftUp": .leftUp,
        "rightDown": .rightDown, "rightUp": .rightUp
    ]
    
    lazy var delegate: ControllerDelegate? = nil
    
    func parseCommand(_ command: String) {
        if let cmd = commands[command] {
            self.delegate?.controller(self, didPressButton: cmd)
        }
    }
}

protocol ControllerManagerDelegate {
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller)
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller)
}

extension ControllerManagerDelegate {
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller) { }
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) { }
}

class ControllerManager: MultipeerDelegate {
    
    var controllers: [String:Controller] = [:]
    
    var delegate: ControllerManagerDelegate?
    
    
    func peerConnected(peer: String, withDisplayName displayName: String) {
        let controller = Controller()
        controller.id = peer
        controller.displayName = displayName
        
        controllers.updateValue(controller, forKey: controller.id)
        
        delegate?.controllerManager(self, controllerConnected: controller)
    }
    
    func peerDisconnected(peer: String) {
        
        if let controller = controllers[peer] {
            delegate?.controllerManager(self, controllerDisconnected: controller)
            controllers.removeValue(forKey: peer)
        }
    }
    
    func peerSentMessage(peer: String, message: String) {
        controllers[peer]?.parseCommand(message)
    }
}
