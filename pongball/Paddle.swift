//
//  Paddle.swift
//  pongball
//
//  Created by Matheus Martins on 2/3/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class PaddleNode : SKNode {
    
    var sprite: SKSpriteNode!
    
    
    override init() {
    
        super.init()
        
        setupSprite()
        setupPhysicsBody()
    }

    
    func setupSprite() {
        
        // create shape
        let shape = SKShapeNode(rectOf: CGSize(width: 100.0, height: 20.0))
        shape.fillColor = SKColor.orange
        
        // assign sprite from shape
        self.sprite = SKSpriteNode(texture: shape.texture())
        
        // add sprite as child
        self.addChild(self.sprite)
    }
    
    func setupPhysicsBody() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100.0, height: 20.0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
