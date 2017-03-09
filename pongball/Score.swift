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
    var tileTexture:SKTexture! = SKTexture(imageNamed: "tile_blue"){
        didSet{
            self.setupSprite()
        }
    }
    private var tileSprite:SKSpriteNode!
    private var crownSprite:SKSpriteNode!
    var owner:Player!
    var isWinning:Bool = false {
        didSet {
            if isWinning == true {
                self.activeCrown()
            }else {
                self.desactiveCrown()
            }
        
        }
    }
    
    init(withOwner owner: Player) {
        super.init()
        self.owner = owner
        setupSprite()
        setupLabel()
    }
    
    override init() {
        super.init()
        setupSprite()
        setupLabel()
    }
    
    private func setupLabel(){
        label  = SKLabelNode()
        label.text = "00"
        label.fontName = "silkscreen"
        label.position = CGPoint(x: 60, y: -17)//ajeitar isso depois para que nao fique um numéro mágico
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.fontSize = 50
        addChild(label)
    }
    
    private func setupSprite(){
        tileSprite?.removeFromParent()
        tileSprite = SKSpriteNode(texture: tileTexture)
        addChild(tileSprite)
    }
    
    private func activeCrown(){
        if self.crownSprite == nil {
            let crownTexture = SKTexture(image:#imageLiteral(resourceName: "crown.png"))
            self.crownSprite = SKSpriteNode(texture: crownTexture)
        }
        self.crownSprite.removeFromParent()
        addChild(self.crownSprite)
        self.crownSprite.position = CGPoint(x: 230, y: 0)
    }
    
    private func desactiveCrown(){
        if self.crownSprite != nil {
            self.crownSprite.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
