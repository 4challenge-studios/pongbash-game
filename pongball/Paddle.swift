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
    
    var moveRight: Bool = false
    var moveLeft: Bool = false
    
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
        self.physicsBody?.affectedByGravity = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaddleNode: Updatable {
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        if (self.moveLeft) {
            let dx =  -(CGFloat)(deltaTime)*speed
            self.position = self.position.offset(dx: dx, dy: 0.0)
        }
        else if(self.moveRight) {
            let dx = (CGFloat)(deltaTime)
            self.position = self.position.offset(dx: dx, dy: 0.0)
        }
    }
}

extension PaddleNode: ControllerDelegate {
    
    func Controller(_ controller: Controller, didPressButton button: ControllerButton) {
        
        switch(button) {
        case .Left:
            self.moveLeft = true
        case .Right:
            self.moveRight = true
        case .Kick:
            break
        }
    }
    
    func Controller(_ controller: Controller, didReleaseButton button: ControllerButton) {
        
        switch(button) {
        case .Left:
            self.moveLeft = false
        case .Right:
            self.moveRight = false
        case .Kick:
            break
        }
    }
}
