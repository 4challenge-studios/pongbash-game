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
    
    var players = [Player(), Player(), Player(), Player()]
    var gameArea: GameAreaNode!
    
    override func didMove(to view: SKView) {
        self.setupGameArea()
        self.physicsWorld.contactDelegate = gameArea
    }
    
    func setupGameArea() {
        let gameAreaSize = CGSize(width: view!.frame.height, height: view!.frame.height)
        self.gameArea = GameAreaNode(withSize: gameAreaSize)
        addChild(self.gameArea)
        self.gameArea.setup()
        self.gameArea.goals.forEach {$0.delegate = self}
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
    
    //gambis
    var playerCount = 0
}

extension GameScene: ControllerManagerDelegate, ControllerDelegate {
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller) {
        let player = Player(withController: controller)
        //players.append(player)
        //controller.delegate = gameArea.paddles[players.count-1]
        controller.delegate = gameArea.paddles[playerCount]
        //gambis
        players[self.playerCount] = player
        self.playerCount += 1
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) {
        
        print("\(controller.displayName) desconectou!")
    }
}

extension GameScene: GoalDelegate{
    func goal(_ goal: GoalNode, didReceiveBall ball: BallNode) {
        if let ballOwner = ball.owner{
            if goal.owner === ballOwner {
                goal.owner.score -= 25
            }else {
                ballOwner.score += 100
            }
        }else {
           goal.owner.score -= 25
        }
        print("\(ball.owner?.name) fez gol em \(goal.owner.name)")
    }
}
