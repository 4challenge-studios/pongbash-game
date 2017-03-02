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
    var scoreLabels: [ScoreNode]! = [ScoreNode]()
    var gameTimer = GameTimerNode(withTime: 30)
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(r: 38, g: 38, b: 38, alpha: 1.0)
        self.setupGameArea()
        
        for (k,v) in self.gameArea.paddles.enumerated() {
            v.owner = players[k]
            players[k].controller?.delegate = v
            players[k].name = "player\(k)"
        }
        
        for (k,v) in self.gameArea.goals.enumerated() {
            v.owner = players[k]
        }
        
        self.physicsWorld.contactDelegate = gameArea
        self.setupScores()
        self.setupGameTimer()
        
    }
    
    func setupGameTimer(){
        self.addChild(self.gameTimer)
        self.gameTimer.position = CGPoint(x: -0.4*(scene?.size.width)!, y:0.4*(scene?.size.height)!)
        gameTimer.start()
    }
    
    func setupGameArea() {
        let gameAreaSize = CGSize(width: view!.frame.height, height: view!.frame.height)
        self.gameArea = GameAreaNode(withSize: gameAreaSize)
        addChild(self.gameArea)
        self.gameArea.setup()
        self.gameArea.goals.forEach {$0.delegate = self}
    }
    
    func setupScores(){
        let height = self.size.height
        let width = self.size.width
        for i in 0..<self.players.count {
            let scoreLabel = ScoreNode(withOwner:players[i])
            scoreLabel.position = CGPoint(x:width/3,y:(0.415 - CGFloat(i) * 0.1)*height)
            
            let texture = self.gameArea.paddles[i].style.tileTexture
            scoreLabel.tileTexture = texture
            scoreLabels.append(scoreLabel)
            addChild(scoreLabel)
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

extension GameScene: GoalDelegate {
    
    func goal(_ goal: GoalNode, didReceiveBall ball: BallNode) {
        
        goal.owner?.score += -25
        
        let isSame = (goal.owner === ball.owner)
        
        ball.owner?.score += isSame ? 0 : 100
        
        print("\(ball.owner?.name) fez gol em \(goal.owner?.name)")
        let sortedPlayers = players.sorted {$0.score > $1.score}
        let playersWithSameScore = (sortedPlayers.filter {
          $0.score == sortedPlayers.first?.score
        }).count
        scoreLabels.forEach { (score) in
            if let owner = score.owner {
                let string = String(format:"%02d",owner.score)
                score.label.text = string
                if score.owner === sortedPlayers.first && playersWithSameScore < 2{
                    score.isWinning = true
                }else {
                    score.isWinning = false
                }
             }
        }
    }
}
