//
//  Paddle.swift
//  pongball
//
//  Created by Matheus Martins on 2/3/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class PaddleNode : TiledNode {
    
    var sprite: SKSpriteNode!
    
    var moveRight: Bool = false
    var moveLeft: Bool = false
    let tileTexture = SKTexture(image: #imageLiteral(resourceName: "tile-01.png"))

    
    
    init() {
        super.init(withTileSize: tileTexture.size())
        setupTiles()
    }
    
    
    private func setupTiles() {
        
        let node1 = SKSpriteNode(texture: tileTexture)
        let physicBody1 = SKPhysicsBody(rectangleOf: tileTexture.size())
        node1.physicsBody = physicBody1
        node1.physicsBody?.categoryBitMask = CategoryBitmasks.corner.rawValue
        node1.physicsBody?.collisionBitMask = CategoryBitmasks.ball.rawValue
        node1.physicsBody?.affectedByGravity = false
        node1.physicsBody?.isDynamic = false
        
        let node2 = SKSpriteNode(texture: tileTexture)
        let physicBody2 = SKPhysicsBody(rectangleOf: tileTexture.size())
        node2.physicsBody = physicBody2
        node2.physicsBody?.categoryBitMask = CategoryBitmasks.corner.rawValue
        node2.physicsBody?.collisionBitMask = CategoryBitmasks.ball.rawValue
        node2.physicsBody?.affectedByGravity = false
        node2.physicsBody?.isDynamic = false
        
        let node3 = SKSpriteNode(texture: tileTexture)
        let physicBody3 = SKPhysicsBody(rectangleOf: tileTexture.size())
        node3.physicsBody = physicBody3
        node3.physicsBody?.categoryBitMask = CategoryBitmasks.corner.rawValue
        node3.physicsBody?.collisionBitMask = CategoryBitmasks.ball.rawValue
        node3.physicsBody?.affectedByGravity = false
        node3.physicsBody?.isDynamic = false
        
        addChild(node1, atPosition: CGPoint(x: 0, y: 0))
        addChild(node2, atPosition: CGPoint(x: 1, y: 0))
        addChild(node3, atPosition: CGPoint(x: 2, y: 0))
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
