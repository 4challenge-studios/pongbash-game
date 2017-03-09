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
        self.setupBalls()
        let iphones = self["player*"] as? [SKSpriteNode]
        for iphone in iphones! {
            let label = iphone.childNode(withName: "label") as! SKLabelNode
            self.setupAnimation(forLabel: label)
        }
        
        for (i,p) in self.players.enumerated() {
            
            guard p.controller != nil else { continue }
            
            p.controller?.delegate = self
            p.controller?.sendCommand(p.style.rawValue)
            self.setLabelText(p.controller!.displayName, atPlayerId: i)
        }
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
        label?.removeAllActions()
        label?.text = text
    }
    
    func setupAnimation(forLabel label:SKLabelNode){
            let action0 = SKAction.run{
                label.text = "wait."
            }
            let action1  =  SKAction.run{
                label.text = "wait.."
            }

            let action2 =  SKAction.run{
                label.text = "wait..."
            }
            let waitAction = SKAction.wait(forDuration: 0.5)
            let sequence = SKAction.sequence([action0,waitAction,action1,waitAction,action2,waitAction])
            let repeatForever = SKAction.repeatForever(sequence)
            label.run(repeatForever)
    }
    
    func setupBalls(){
        let balls = self["ball*"] as? [SKSpriteNode]
        for ball in balls! {
            ball.zPosition = -2
        }
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
                print(p.controller!)
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
                let playerNode = self["player\(i)"].first as! SKSpriteNode
                let labelNode = playerNode.childNode(withName: "label") as! SKLabelNode
                self.setupAnimation(forLabel: labelNode)
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
