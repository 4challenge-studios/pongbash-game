//
//  Corner.swift
//  pongball
//
//  Created by Vitor Muniz on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class CornerNode: TiledNode {
    
    let tileTexture = SKTexture(image: #imageLiteral(resourceName: "tile-01.png"))
    
    init() {
        super.init(withTileSize: tileTexture.size())
        //setupPhysicsBody()
        setupTiles()
    }
    
    
    private func setupTiles() {
        
        let node1 = SKSpriteNode(texture: tileTexture)
        let node2 = SKSpriteNode(texture: tileTexture)
        let node3 = SKSpriteNode(texture: tileTexture)
        addChild(node1, atPosition: CGPoint(x: 0, y: 0))
        addChild(node2, atPosition: CGPoint(x: 0, y: 1))
        addChild(node3, atPosition: CGPoint(x: 1, y: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

