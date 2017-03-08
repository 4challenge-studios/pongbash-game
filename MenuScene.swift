//
//  GameScene.swift
//  pongball
//
//  Created by Matheus Martins on 2/2/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit
import GameController

enum MenuButton {
    case play
}

protocol MenuDelegate: class {
    func menuScene(menuScene: MenuScene, didPressButton button: MenuButton)
    func menuScene(menuScene: MenuScene, didReleaseButton button: MenuButton)
}

class MenuScene: SKScene {
    
    var players = [Player(withStyle: .blue),
                   Player(withStyle: .green),
                   Player(withStyle: .orange),
                   Player(withStyle: .purple)]
    
    weak var menuDelegate: MenuDelegate?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func setLabelText(_ text: String, atPlayerId playerId: Int) {
        let player = self.childNode(withName: "player\(playerId)")
        let label = player?.childNode(withName: "label") as? SKLabelNode
        label?.text = text
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    private var previousTime: TimeInterval = 0.0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension MenuScene: ControllerManagerDelegate, ControllerDelegate {
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller) {
        for (i,p) in self.players.enumerated() {
            
            if let id = p.controller?.id, id == controller.id {
                p.controller = controller
                p.controller?.delegate = self
                p.controller?.sendCommand(p.style.rawValue)
                self.setLabelText(controller.displayName, atPlayerId: i)
                return
            }
        }
        
        for (i,p) in self.players.enumerated() {
            if p.controller == nil {
                p.name = controller.displayName
                p.controller = controller
                p.controller?.delegate = self
                p.controller?.sendCommand(p.style.rawValue)
                print(p.controller)
                self.setLabelText(controller.displayName, atPlayerId: i)
                break
            }
        }
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) {
        
        for (i,p) in self.players.enumerated() {
            if p.controller === controller {
                self.players[i].name = controller.displayName
                self.players[i].controller = nil
                self.setLabelText("WAIT...", atPlayerId: i)
                break
            }
        }
        
        print("\(controller.displayName) desconectou!")
    }
    
    func controller(_ controller: Controller, didSendCommand command: ControllerCommand) {
        if command == .disconnect {

        }
    }
}

extension MenuScene: SiriRemoteDelegate {
    
    func didPress(button: SiriRemoteButton) {
        switch(button) {
        case .select:
            self.menuDelegate?.menuScene(menuScene: self, didPressButton: .play)
        default:
            break
        }
    }
    
    func didRelease(button: SiriRemoteButton) {

    }
}
