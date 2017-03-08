//
//  ControllerManager.swift
//  pongball
//
//  Created by Matheus Martins on 2/10/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum ControllerCommand {
    case leftDown
    case leftUp
    case rightDown
    case rightUp
    case kick
    case disconnect
    case invalid
    
    static let stringToCommands: [String:ControllerCommand] = [
        "kick": .kick, "leftDown": .leftDown, "leftUp": .leftUp,
        "rightDown": .rightDown, "rightUp": .rightUp, "disconnect": .disconnect
    ]
    
    static func fromString(_ string: String) -> ControllerCommand {
        return stringToCommands[string] ?? .invalid
    }
}

protocol ControllerDelegate {
    func controller(_ controller: Controller, didSendCommand command: ControllerCommand)
}

extension ControllerDelegate {
    func controller(_ controller: Controller, didSendCommand command: ControllerCommand) { }
}

class Controller {
    var id: String = ""
    var displayName: String = ""
    weak var peerID: MCPeerID?
    weak var session: MCSession?
    
    lazy var delegate: ControllerDelegate? = nil
    
    func parseCommand(_ command: String) {
        let cmd = ControllerCommand.fromString(command)
        self.delegate?.controller(self, didSendCommand: cmd)
    }
    
    func sendCommand(_ command: String) {
        
        guard let peerID = self.peerID else { return }
        guard let data = command.data(using: .utf8, allowLossyConversion: false) else { return }
        
        do {
            try session?.send(data, toPeers: [peerID], with: .reliable)
        } catch {
            
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
    
    
    func peerConnected(withSession session: MCSession, withPeerID peerID: MCPeerID,
                       withDeviceID deviceID: String, withDisplayName displayName: String) {
        
        let controller = Controller()
        
        controller.peerID = peerID
        controller.id = deviceID
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
