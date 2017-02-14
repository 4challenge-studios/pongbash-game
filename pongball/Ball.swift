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
    var radius: CGFloat = 15.0 {
        didSet {
            setupSprite()
            setupPhysicsBody()
        }
    }
    
    var owner:String?
    //let ballSize = CGFloat(30.0)
    
    override init() {
        super.init()
        setupSprite()
        setupPhysicsBody()
    }
    
    
    private func setupSprite() {
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "white-01.png"))
        self.sprite = SKSpriteNode(texture: texture)
        self.sprite.size = CGSize(width: self.radius*2, height: self.radius*2)
        //self.sprite.xScale = 0.5
        //self.sprite.yScale = 0.5
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
        self.physicsBody?.contactTestBitMask = CategoryBitmasks.goal.rawValue
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

