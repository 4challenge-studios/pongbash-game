//
//  IncreaseSizePickUp.swift
//  pongball
//
//  Created by Vitor Muniz on 20/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit
class IncreaseSizeItemNode: ItemNode {
    
    var sprite:SKSpriteNode!
    override func wasCollected(byPlayer player: Player) {
        let gameArea = self.parent as! GameAreaNode
        let paddles = gameArea.paddles
        for paddle in paddles {
            if paddle.owner === player {
                increasePaddleSize(paddle: paddle,timeInterval:5)
                return
            }
        }
    }
    func increasePaddleSize(paddle:PaddleNode,timeInterval:TimeInterval){
        
        if paddle.tiles.count >= 4 { return }
        
        paddle.increaseSize()
        Timer.after(timeInterval) {
            paddle.decreaseSize()
        }
    }
    
    private func setupSprite() {
        
        let texture = SKTexture(imageNamed: "pickup_size_up")
        self.sprite = SKSpriteNode(texture: texture)
        self.sprite.zPosition = -1
        // add sprite as child
        self.addChild(self.sprite)
    }
    
    private func setupPhysicsBody(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: 25, center: CGPoint(x:0,y:0))
        self.physicsBody?.categoryBitMask = CategoryBitmasks.item.rawValue
        self.physicsBody?.collisionBitMask =  CategoryBitmasks.ball.rawValue
        self.physicsBody?.contactTestBitMask = CategoryBitmasks.ball.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    override init() {
        super.init()
        setupSprite()
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
