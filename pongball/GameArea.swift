//
//  GameArea.swift
//  pongball
//
//  Created by Vitor Muniz on 13/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//


import Foundation
import SpriteKit

class GameAreaNode : SKNode {
    
    var paddles = [PaddleNode]()
    var balls = [BallNode]()
    var goals = [GoalNode]()
    
    
    let size: CGSize
    
    init(withSize size: CGSize) {
        self.size = size
        super.init()
    }
    
    func setup() {
        setupGoals()
        setupCorners()
        setupPaddles()
        setupBalls()
    }
    
    private func setupBalls() {
        
        self.balls = [BallNode()]
        
        for ball in self.balls {
            self.addChild(ball)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            let dx = ball.physicsBody?.velocity.dx
            let dy = ball.physicsBody?.velocity.dy
            let angle = atan2(dy!, dx!)
            
            let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
            ball.run(action)
            ball.isKicked = true
        }
    }
    
    private func setupGoals() {
        let rect0 = CGRect(x:-size.width/2 - size.width/16 , y: -size.height/2, width: size.width/16, height: size.height)
        let rect1 = CGRect(x: -size.width/2, y: size.height/2, width: size.width, height: size.height/16)
        let rect2 = CGRect(x: size.width/2, y: -size.height/2, width: size.width/16, height: size.height)
        let rect3 = CGRect(x: -size.width/2, y: -size.height/2  - size.height/16, width: size.width, height: size.width/16)
        
        self.goals =
            [GoalNode(rect: rect0, owner: "purple"),
             GoalNode(rect: rect1, owner: "orange"),
             GoalNode(rect: rect2, owner: "blue"),
             GoalNode(rect: rect3, owner: "red")]
        
        self.goals.forEach { self.addChild($0) }
    }
    
    private func setupCorners() {
        let corners = [CornerNode(), CornerNode(),
                       CornerNode(), CornerNode()]
        
        corners[0].position = CGPoint(x: -self.size.width/2, y: -self.size.height/2)//CGPoint(x: , y: 100)
        corners[1].position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        corners[1].zRotation = CGFloat(M_PI_2)
        corners[2].position = CGPoint(x: -self.size.width/2, y: self.size.height/2)
        corners[2].zRotation = -CGFloat(M_PI_2)
        corners[3].position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        corners[3].zRotation = CGFloat(M_PI)
        
        corners.forEach { self.addChild($0) }
    }
    
    private func setupPaddles() {
        
        self.paddles = [PaddleNode(), PaddleNode(),
                        PaddleNode(), PaddleNode()]
        
        let centerPaddle0Position = -self.size.width/8+(paddles[0].tileSize.width)/2
        let centerPaddle1Position = self.size.width/8 + (paddles[0].tileSize.width)/2
        let centerPaddle2Position = -self.size.width/8+(paddles[0].tileSize.width)/2
        let centerPaddle3Position = -self.size.width/8+(paddles[0].tileSize.width)/2
        paddles[0].position = CGPoint(x:centerPaddle0Position, y: -self.size.height/2)
        paddles[1].position = CGPoint(x:self.size.width/2, y: -centerPaddle1Position)
        paddles[1].zRotation = CGFloat(M_PI_2)
        paddles[2].zRotation = CGFloat(-M_PI_2)
        paddles[2].position = CGPoint(x:-self.size.width/2, y: centerPaddle2Position)
        paddles[3].zRotation = CGFloat(-M_PI)
        paddles[3].position = CGPoint(x:centerPaddle3Position, y: self.size.height/2)
        
        self.paddles.forEach {
            self.addChild($0)
            let kick = KickNode(withRadius:1.5 * $0.tileTexture.size().width)
            kick.zRotation = CGFloat(M_PI_2)
            kick.position = CGPoint(x:1.5 * $0.tileTexture.size().width ,y:$0.tileTexture.size().height)
            $0.addChild(kick)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameAreaNode: SKPhysicsContactDelegate {
    
    
    func didBegin(_ contact:SKPhysicsContact){
    }
    func didEnd(_ contact:SKPhysicsContact){
        if contact.bodyB.categoryBitMask == CategoryBitmasks.ball.rawValue {
            //rotaciona a bola para a direcao certa
            let ball = contact.bodyB.node
            let dx = ball?.physicsBody?.velocity.dx
            let dy = ball?.physicsBody?.velocity.dy
            let angle = atan2(dy!, dx!)
            let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
            
            print(angle)
            ball?.run(action)
            
        } else if contact.bodyA.categoryBitMask == CategoryBitmasks.ball.rawValue {
            //rotaciona a bola para a direcao certa
            let ball = contact.bodyA.node
            let dx = ball?.physicsBody?.velocity.dx
            let dy = ball?.physicsBody?.velocity.dy
            let angle = atan2(dy!, dx!)
            
            let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
            print(angle)
            ball?.run(action)

        }
    }
}

extension GameAreaNode: Updatable {
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        self.children.forEach {
            if let updatable = $0 as? Updatable {
                updatable.update(currentTime, deltaTime)
            }
        }
    }
}
