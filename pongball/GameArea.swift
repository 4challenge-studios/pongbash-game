//
//  GameArea.swift
//  pongball
//
//  Created by Vitor Muniz on 13/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//


import Foundation
import SpriteKit

class GameAreaNode : SKCropNode {
    
    let size: CGSize
    
    var paddles = [PaddleNode]()
    var balls = [BallNode]()
    var goals = [GoalNode]()
    var itemGenerator:Timer!
    init(withSize size: CGSize) {
        self.size = size
        super.init()
    }
    
    func setup() {
        setupGoals()
        setupCorners()
        setupPaddles()
        setupItemGenerator()
        let background = SKSpriteNode(color: .black, size: self.size)
        addChild(background)
        background.zPosition = -1
        self.maskNode = background
    }
    
    func setupBalls() {
        
        self.balls = [BallNode(),BallNode(),BallNode()]
        
        for ball in self.balls {
            self.addChild(ball)
            ball.physicsBody?.applyImpulse(CGVector(dx: Int(Int(arc4random()%40)), dy:Int(arc4random()%40)))
            let dx = ball.physicsBody?.velocity.dx
            let dy = ball.physicsBody?.velocity.dy
            let angle = atan2(dy!, dx!)
            
            let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
            ball.run(action)
        }
    }
    
    func setupGoals() {
        
        
        let rect0 = CGRect(x: 0, y: 0, width: size.width, height: size.height/16)
        let rect1 = CGRect(x: 0, y: 0, width: size.width, height: size.width/16)
        let rect2 = CGRect(x: 0, y: 0, width: size.width/16, height: size.height)
        let rect3 = CGRect(x: 0, y: 0, width: size.width/16, height: size.height)
        
        self.goals = [GoalNode(rect: rect0),
             GoalNode(rect: rect1),
             GoalNode(rect: rect2),
             GoalNode(rect: rect3)]
        
        // bottom
        self.goals[0].position = CGPoint(x: -size.width/2, y: -size.height/2  - size.height/16)
        // top
        self.goals[1].position = CGPoint(x: -size.width/2, y: size.height/2)
        // left
        self.goals[2].position = CGPoint(x:-size.width/2 - size.width/16 , y: -size.height/2)
        // right
        self.goals[3].position = CGPoint(x: size.width/2, y: -size.height/2)
        
        self.goals.forEach { self.addChild($0) }
    }
    
    func setupCorners() {
        let corners = [CornerNode(), CornerNode(),
                       CornerNode(), CornerNode()]
        
        corners[0].position = CGPoint(x: -self.size.width/2, y: -self.size.height/2)
        corners[1].position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        corners[1].zRotation = CGFloat(M_PI_2)
        corners[2].position = CGPoint(x: -self.size.width/2, y: self.size.height/2)
        corners[2].zRotation = -CGFloat(M_PI_2)
        corners[3].position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        corners[3].zRotation = CGFloat(M_PI)
        
        corners.forEach { self.addChild($0) }
    }
    
    func setupPaddles() {
        
        let players = (scene as! GameScene).players
        
        self.paddles = [PaddleNode(withLocation: .bottom, andStyle: players[0].style),
                        PaddleNode(withLocation: .top, andStyle: players[1].style),
                        PaddleNode(withLocation: .left, andStyle: players[2].style),
                        PaddleNode(withLocation: .right, andStyle: players[3].style)]
        
        self.paddles.forEach { $0.name = $0.style.rawValue }
        
        let centerPaddle0Position = -self.size.width/8+(paddles[0].tileSize.width)/2
        let centerPaddle1Position = self.size.width/8+(paddles[0].tileSize.width)/2
        let centerPaddle2Position = -self.size.width/8+(paddles[0].tileSize.width)/2
        
        paddles[0].position = CGPoint(x:centerPaddle0Position, y: -self.size.height/2)
        
        paddles[1].zRotation = CGFloat(-M_PI)
        paddles[1].position = CGPoint(x:centerPaddle1Position, y: self.size.height/2)
        
        paddles[2].zRotation = CGFloat(-M_PI_2)
        paddles[2].position = CGPoint(x:-self.size.width/2, y: centerPaddle2Position)
        
        paddles[3].position = CGPoint(x:self.size.width/2, y: -centerPaddle1Position)
        paddles[3].zRotation = CGFloat(M_PI_2)
        
        self.paddles.forEach {
            self.addChild($0)
        }
    }
    
    func setupItemGenerator(){
        self.itemGenerator = Timer.new(every:15.0.second) {
            let limit = 600
            let item = arc4random() % 2 == 1 ? IncreaseSizeItemNode() : DecreaseSizeItemNode()
            let x = (Int(arc4random()) % limit) - 300
            let y = (Int(arc4random()) % limit) - 300

            let position = CGPoint(x: Int(x), y: Int(y))
            self.put(item:item, inPosition: position)
        }
        
        self.itemGenerator.start()
    }
    
    func put(item:ItemNode, inPosition position:CGPoint){
        self.addChild(item)
        item.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameAreaNode: SKPhysicsContactDelegate {
    
    
    func didEnd(_ contact:SKPhysicsContact){
        
        (contact.bodyA.node as? ContactDelegate)?.didEndContact(contact)
        (contact.bodyB.node as? ContactDelegate)?.didEndContact(contact)
    }
    
    func didBegin(_ contact:SKPhysicsContact){
        
        (contact.bodyA.node as? ContactDelegate)?.didBeginContact(contact)
        (contact.bodyB.node as? ContactDelegate)?.didBeginContact(contact)
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
