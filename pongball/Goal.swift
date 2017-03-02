//
//  GoalNode.swift
//  pongball
//
//  Created by Vitor Muniz on 13/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

// travessão
class GoalNode : SKNode {
    
    weak var owner: Player?
    var delegate: GoalDelegate?
    
    init(rect:CGRect) {
        
        self.rect = rect
        super.init()
        self.setupPhysicsBody()
    }
    
    var rect: CGRect {
        didSet {
            setupPhysicsBody()
        }
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = false
        self.physicsBody?.friction = 0
        //self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.collisionBitMask = CategoryBitmasks.ball.rawValue
        self.physicsBody?.categoryBitMask = CategoryBitmasks.goal.rawValue
        self.physicsBody?.contactTestBitMask = CategoryBitmasks.ball.rawValue
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalNode:ContactDelegate {
    func didBeginContact(_ contact: SKPhysicsContact){
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        let other = (nodeA as? GoalNode) != nil ? nodeB : nodeA
        if let ball = other as? BallNode {
            self.delegate?.goal(self, didReceiveBall: ball)
        }

    }
}
