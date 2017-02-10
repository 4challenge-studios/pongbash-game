//
//  Corner.swift
//  pongball
//
//  Created by Vitor Muniz on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class CornerNode : SKNode {
    
    var sprite: SKSpriteNode!
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
        //let shape = SKShapeNode(circleOfRadius: self.ballSize)
        sprite = SKSpriteNode(color: .red, size: CGSize(width: 120, height: 120))
        sprite.texture = SKTexture(imageNamed: "corner")
        // assign sprite from shape
        //self.shape = SKSpriteNode(texture: shape.texture())
        
        // add sprite as child
        self.addChild(self.sprite)
    }
    
    private func setupPhysicsBody() {
        
        //setando corpo físico
        let body1 = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 60))
        let body2 = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 120))
        let shapeBody = SKPhysicsBody(bodies: [body1,body2])
        sprite.physicsBody = shapeBody
        //
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        
//        self.physicsBody?.restitution = 1
//        self.physicsBody?.linearDamping = 0//reduce linear velocity
//        self.physicsBody?.angularDamping = 0//reduce angular velocity
//        self.physicsBody?.friction = 0
//        self.physicsBody?.categoryBitMask = 0b01
//        self.physicsBody?.collisionBitMask = 0b10
//        self.physicsBody?.fieldBitMask = 0b0
//        self.physicsBody?.contactTestBitMask = 0b10
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

