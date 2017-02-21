//
//  Ball.swift
//  pongball
//
//  Created by Vitor Muniz on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit


class BallNode : SKNode, Updatable {
    
    weak var owner: Player?
    
    var sprite: SKSpriteNode!
    private let animationDidKick = SKAction.animate(with: [SKTexture(image: #imageLiteral(resourceName: "white-01.png")), SKTexture(image: #imageLiteral(resourceName: "white-02.png")), SKTexture(image: #imageLiteral(resourceName: "white-03.png")), SKTexture(image: #imageLiteral(resourceName: "white-04.png"))], timePerFrame: 0.25, resize: true, restore: true)
    private let animationAfterKick = SKAction.animate(with: [SKTexture(image: #imageLiteral(resourceName: "white-03.png")), SKTexture(image: #imageLiteral(resourceName: "white-04.png"))], timePerFrame: 0.25, resize: true, restore: true)
    private var animation:SKAction!
   
    var radius: CGFloat = 30.0 {
        
        didSet {
            
            setupSprite()
            setupPhysicsBody()
        }
    }
    
    var color: UIColor = .white {
        
        didSet {
            
            self.sprite.color = self.color
        }
    }
    
    var isKicked:Bool = false {
        didSet {
            if isKicked == true {
               sprite.run(self.animation)
            } else {
                self.sprite.removeAllActions()
                self.sprite.removeFromParent()
                self.setupSprite()
                let vel =  self.physicsBody?.velocity
                self.physicsBody?.velocity = vel!/(vel?.length())!  * 400
            }
        }
    }
    
    override init() {
        
        super.init()
        setupSprite()
        setupPhysicsBody()
        setupAnimation()
    }

    private func setupSprite() {
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "white-01.png"))
        self.sprite = SKSpriteNode(texture: texture)
        self.color = .white
        self.sprite.colorBlendFactor = 1.0
        self.sprite.size = CGSize(width: self.radius*2, height: self.radius*2)
        // add sprite as child
        self.addChild(self.sprite)
    }
    
    private func setupPhysicsBody() {
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 0 //reduce linear velocity
        //self.physicsBody?.angularDamping = 0 //reduce angular velocity
        self.physicsBody?.friction = 0
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = CategoryBitmasks.ball.rawValue
        self.physicsBody?.collisionBitMask = CategoryBitmasks.corner.rawValue | CategoryBitmasks.paddle.rawValue | CategoryBitmasks.goal.rawValue
        self.physicsBody?.contactTestBitMask = CategoryBitmasks.corner.rawValue | CategoryBitmasks.paddle.rawValue | CategoryBitmasks.goal.rawValue | CategoryBitmasks.ball.rawValue | CategoryBitmasks.kick.rawValue
    }
    
    private func setupAnimation(){
        let forever = SKAction.repeatForever(animationAfterKick)
        self.animation = SKAction.sequence([animationDidKick,forever])
    }
    
    func updateRotation() {

        let dx = self.physicsBody!.velocity.dx
        let dy = self.physicsBody!.velocity.dy
        let angle = atan2(dy, dx)
        
        let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
        print(angle)
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        
        self.physicsBody!.allContactedBodies().forEach {
            
            if let kick = $0.node as? KickNode, kick.enabled {
                self.isKicked = true
            
                self.owner = kick.paddle!.owner
                self.color = kick.paddle!.color
                
                let kickPos = scene!.convert(kick.position, from: kick.parent!)
                let ballPos = scene!.convert(self.position, from: self.parent!)
                
                let dir = (ballPos - kickPos)
                let vel = CGVector(dx: dir.x, dy: dir.y)
                self.physicsBody?.velocity = vel/(vel.length())  * 800
                
                updateRotation()
            }
        }
    }
}

extension BallNode: ContactDelegate {

    func didBeginContact(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        let other = (nodeA as? BallNode) != nil ? nodeB : nodeA
        
        if let paddle = other as? PaddleNode {
            self.isKicked = false
            
            self.owner = paddle.owner
            self.color = paddle.color
        }
        
        self.updateRotation()
    }
}
