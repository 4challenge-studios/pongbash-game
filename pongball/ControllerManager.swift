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
    var displayName: String = ""
    
    lazy var delegate: ControllerDelegate? = nil
    
    func parseCommand(_ command: String) {
        if command == "chute" {
            self.delegate?.Controller(self, didPressButton: .Kick)
        }
    }
}

protocol ControllerManagerDelegate {
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller)
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller)
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
        
        delegate?.controllerManager(self, controllerDisconnected: controllers[peer]!)
        controllers.removeValue(forKey: peer)
    }
    
    func peerSentMessage(peer: String, message: String) {
        controllers[peer]?.parseCommand(message)
        print("------------------")
        print("\(peer):\(message)")
    }
}
