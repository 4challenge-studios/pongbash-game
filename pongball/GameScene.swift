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
    var scoreLabels = [ScoreNode(),ScoreNode(),ScoreNode(),ScoreNode()]
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
        self.setupLabels()
    }
    
    func setupLabels(){
        let height = self.size.height
        let width = self.size.width
        for i in 0..<self.scoreLabels.count {
            scoreLabels[i].position = CGPoint(x:width/3,y:(0.25 + CGFloat(i) * 0.05)*height)
            scoreLabels[i].text = "00"
            scoreLabels[i].fontName = "silkscreen"
            addChild(scoreLabels[i])
            scoreLabels[i].owner = self.gameArea.paddles[i].owner
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
        
        let player = Player(withController: controller)

        for (i,p) in self.players.enumerated() {
            if p.controller == nil {
                self.players[i] = player
                gameArea.paddles[i].owner = player
                gameArea.goals[i].owner = player
                self.scoreLabels[i].owner = player
                controller.delegate = gameArea.paddles[i]
                break
            }
        }
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) {
        
        print("\(controller.displayName) desconectou!")
    }
}

extension GameScene: GoalDelegate {
    
    func goal(_ goal: GoalNode, didReceiveBall ball: BallNode) {
        
        goal.owner?.score += -25
        
        let isSame = (goal.owner === ball.owner)
        
        ball.owner?.score += isSame ? 0 : 100
        
        print("\(ball.owner?.name) fez gol em \(goal.owner?.name)")
        scoreLabels.forEach { (score) in
            if let owner = score.owner {
                if owner === ball.owner {
                    score.text = "\(owner.score)"
                }
            }
        }
    }
}
