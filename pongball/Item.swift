//
//  Power.swift
//  pongball
//
//  Created by Vitor Muniz on 19/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class ItemNode:SKNode,ContactDelegate{
    internal func didBeginContact(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        let other = (nodeA as? ItemNode) != nil ? nodeB : nodeA
        let ball = other as? BallNode
        if let owner = ball?.owner {
            wasCollected(byPlayer: owner)
            self.removeFromParent()
        }
        
    }
    internal func didEndContact(_ contact: SKPhysicsContact) {
        
    }
    
    func wasCollected(byPlayer player:Player){
        
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





