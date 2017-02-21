//
//  Score.swift
//  pongball
//
//  Created by Vitor Muniz on 17/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit
class ScoreNode: SKNode {
    
    var label:SKLabelNode!
    var tileSprite:SKSpriteNode!
    var crownSprite:SKSpriteNode!
    var owner:Player!
    var color: UIColor = .white {
        didSet {
            self.tileSprite.color = self.color
        }
    }
    
    
    init(withOwner owner: Player) {
        super.init()
        self.owner = owner
        setupSprites()
        setupLabel()
    }
    
    override init() {
        super.init()
        setupSprites()
        setupLabel()
    }
    
    private func setupLabel(){
        label  = SKLabelNode()
        label.text = " - 00"
        label.fontName = "silkscreen"
        label.position = CGPoint(x: 100, y: -10)//ajeitar isso depois para que nao fique um numeor magico
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(label)
    }
    
    private func setupSprites(){
        let tileTexture = SKTexture(image: #imageLiteral(resourceName: "green_tile.png"))
        tileSprite = SKSpriteNode(texture: tileTexture)
        tileSprite.colorBlendFactor = 1.0
        addChild(tileSprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
