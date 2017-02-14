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
    
    override init() {
        super.init()
        setupSprite()
        setupPhysicsBody()
    }
    
    
    private func setupSprite() {
        
    }
    
    private func setupPhysicsBody() {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

