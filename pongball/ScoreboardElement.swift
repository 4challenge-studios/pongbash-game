//
//  ScoreboardElement.swift
//  pongball
//
//  Created by Vitor Muniz on 06/03/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    func texture() -> SKTexture? {
        return SKView().texture(from: self)
    }
}

class ScoreboardElement {
    
    var crown:SKSpriteNode!
    var tile:SKSpriteNode!
    var score:SKLabelNode!
    var playerName:SKLabelNode!
    
    init(withNode node: SKNode) {
        self.crown = node.children[0].childNode(withName: "crown") as! SKSpriteNode
        //self.playerName = node.children[0].childNode(withName: "player_name") as! SKLabelNode
        self.tile = node.children[0].childNode(withName: "tile") as! SKSpriteNode
        self.score = node.children[0].childNode(withName: "score") as! SKLabelNode
        
        self.playerName = node.children[0].childNode(withName: "player_name") as! SKLabelNode
        self.playerName.isHidden = true
    }
    
    func updatePlayerName(_ name: String) {
        //workaround
        self.playerName.isHidden = false
        self.playerName.text = name
        let sprite = SKSpriteNode(texture: self.playerName.texture())
        sprite.anchorPoint = CGPoint.zero
        sprite.position = self.playerName.position
        self.playerName.parent!.addChild(sprite)
        self.playerName.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
