//
//  Kick.swift
//  pongball
//
//  Created by Vitor Muniz on 15/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import Foundation
import SpriteKit

class KickNode : SKNode {
    
    var sprite: SKSpriteNode!
    var animation: SKAction?
    var enabled: Bool = false
    
    var radius: CGFloat = 30.0 {
        didSet {
            setupSprite()
            setupPhysicsBody()
        }
    }
    
    init(withRadius radius:CGFloat) {
        super.init()
        self.radius = radius
        setupSprite()
        setupPhysicsBody()
    }
    
    private func setupSprite(){
        let texture = SKTexture(image: #imageLiteral(resourceName: "pulse.png"))
        self.sprite = SKSpriteNode(texture: texture)
        self.sprite.alpha = 0.0
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.25)
        self.sprite.xScale = 2.0
        self.sprite.yScale = 2.0
        self.sprite.zRotation = -CGFloat(M_PI_2)
        self.addChild(self.sprite)
    }
    
    private func setupPhysicsBody(){
        let bezier =  UIBezierPath(arcCenter: CGPoint(x:0.0,y:0.0), radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(-M_PI_2), clockwise: false)
        let halfCirclePath = bezier.cgPath
        self.physicsBody = SKPhysicsBody(polygonFrom:halfCirclePath)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = CategoryBitmasks.kick.rawValue
        self.physicsBody?.collisionBitMask = CollisionBitmasks.none.rawValue
        self.physicsBody?.contactTestBitMask = CategoryBitmasks.ball.rawValue | CategoryBitmasks.kick.rawValue
    }
    
    func animateKick() {
        let appear = SKAction.fadeIn(withDuration: 0.125)
        let disappear = SKAction.fadeOut(withDuration: 0.125)
        self.sprite.run(SKAction.sequence([appear, disappear]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
