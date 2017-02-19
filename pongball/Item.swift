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
        
        let other = (nodeA as? BallNode) != nil ? nodeB : nodeA

        if let ball = other as? BallNode {
            let gameArea = ball.parent as! GameAreaNode
            let paddles = gameArea.paddles
            for paddle in paddles {
                if  ball.owner === paddle.owner {
                    didCollected(byPlayerPaddle:paddle)
                    return
                }
            }
        }
    }
    internal func didEndContact(_ contact: SKPhysicsContact) {
        
    }
    
    func didCollected(byPlayerPaddle paddle:PaddleNode){
        //método a ser sobrescrito
        //tá estranho os nomes e os objetos dos parametros
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





