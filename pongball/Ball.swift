//
//  Ball.swift
//  pongball
//
//  Created by Vitor Muniz on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class BallNode : SKNode {
    
    var sprite: SKSpriteNode!
    let ballSize = CGFloat(15.0)
    var color: UIColor = .orange {
        didSet {
            setupSprite()
        }
    }
    
    override init() {
        super.init()
        setupSprite()
        setupPhysicsBody()
    }
    
    
    private func setupSprite() {
        
        if((sprite) != nil) { sprite.removeFromParent() }
        
        // create shape
        let shape = SKShapeNode(circleOfRadius: self.ballSize)
        shape.fillColor = color
        
        // assign sprite from shape
        self.sprite = SKSpriteNode(texture: shape.texture())
        
        // add sprite as child
        self.addChild(self.sprite)
    }
    
    private func setupPhysicsBody() {
        
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.ballSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 0 //reduce linear velocity
        self.physicsBody?.angularDamping = 0 //reduce angular velocity
        self.physicsBody?.friction = 0
        self.physicsBody?.categoryBitMask = 0b10
        self.physicsBody?.collisionBitMask = 0b10
        self.physicsBody?.fieldBitMask = 0b0
        self.physicsBody?.contactTestBitMask = 0b01
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

