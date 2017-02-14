//
//  TiledNode.swift
//  pongball
//
//  Created by Matheus Martins on 2/14/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class TiledNode: SKNode {
    
    let tileSize: CGSize

    init(withTileSize tileSize: CGSize) {
        self.tileSize = tileSize
        super.init()
    }
    
    func addChild(_ node: SKNode, atPosition position: CGPoint) {
        
        self.addChild(node)
        node.position = CGPoint(x: position.x*tileSize.width,
                                y: position.y*tileSize.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
