//
//  GameScene.swift
//  pongball
//
//  Created by Matheus Martins on 2/2/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController



class GameScene: SKScene {
    
    var players = [Controller]()
    var gameArea: GameAreaNode!
    private var balls:[BallNode]!
    
    override func didMove(to view: SKView) {
        
        //self.balls = [BallNode(),BallNode(),BallNode(),BallNode()]
        self.balls = [BallNode()]
        
        self.physicsWorld.contactDelegate = gameArea
        
        GCController.startWirelessControllerDiscovery {
            print("wow \(GCController.controllers())")
        }
        
        self.setupGameArea()
    }
    
    func setupGameArea() {
        let gameAreaSize = CGSize(width: view!.frame.height, height: view!.frame.height)
        self.gameArea = GameAreaNode(withSize: gameAreaSize)
        addChild(self.gameArea)
        
        // ESSE FOR TÁ MELHOR IN MY OPINION, MAS, FIKDIK
        for ball in balls {
            gameArea.addChild(ball)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random()%50), dy: 10))
            let dx = ball.physicsBody?.velocity.dx
            let dy = ball.physicsBody?.velocity.dy
            let angle = atan2(dy!, dx!)
            
            let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
            ball.run(action)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        
        print(GCController.controllers())
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
        
        var deltaTime = currentTime - previousTime
        if(previousTime == 0) { deltaTime = 0 }
        
        self.children.forEach {
            if let updatable = $0 as? Updatable {
                updatable.update(currentTime, deltaTime)
            }
        }
        
        previousTime = currentTime
    }
    
}

extension GameScene: ControllerManagerDelegate, ControllerDelegate {
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller) {
        
        players.append(controller)
        controller.delegate = gameArea.paddles[players.count-1]
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) {
        
        print("\(controller.displayName) desconectou!")
    }
    
    func controller(_ controller: Controller, didPressButton button: ControllerButton) {

    }
}
