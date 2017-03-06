//
//  ScoreboardElement.swift
//  pongball
//
//  Created by Vitor Muniz on 06/03/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreboardElement {
    
    var crown:SKSpriteNode!
    var tile:SKSpriteNode!
    var score:SKLabelNode!
    var playerName:SKLabelNode!
    var style: Style = .white {
        didSet {
            //self.setupSprite()
        }
    }
    
    init(withNode node: SKNode) {
        self.crown = node.children[0].childNode(withName: "crown") as! SKSpriteNode
        self.playerName = node.children[0].childNode(withName: "player_name") as! SKLabelNode
        self.tile = node.children[0].childNode(withName: "tile") as! SKSpriteNode
        self.score = node.children[0].childNode(withName: "score") as! SKLabelNode
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
