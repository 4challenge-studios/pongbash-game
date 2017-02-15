//
//  ControllerTestScene.swift
//  pongball
//
//  Created by Matheus Martins on 2/13/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit
import GameplayKit

class ControllerTestScene: SKScene, ControllerManagerDelegate, ControllerDelegate {
    
    var players = [String:Int]()
    
    override func didMove(to view: SKView) {
    
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller) {
        
        controller.delegate = self
        
        if let _ = players[controller.id] {
            print("\(controller.displayName) reconectou!")
        } else {
            print("\(controller.displayName) conectou!")
            players.updateValue(0, forKey: controller.id)
        }
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) {
        
        print("\(controller.displayName) desconectou!")
    }
    
    func controller(_ controller: Controller, didPressButton button: ControllerButton) {

    }
}
