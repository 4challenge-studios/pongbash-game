//
//  Paddle.swift
//  pongball
//
//  Created by Matheus Martins on 2/3/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class PaddleNode : TiledNode {
    
    weak var owner: Player?
    
    var sprite: SKSpriteNode!
    var tiles = [SKSpriteNode]()
    var kick: KickNode!
    
    var moveRight: Bool = false
    var moveLeft: Bool = false
    let tileTexture = SKTexture(image: #imageLiteral(resourceName: "tile-01.png"))
    var canKick: Bool = true
    
    static var colorIndex = 0
    static var colors: [UIColor] = [.red, .green, .blue, .yellow]
    var color: UIColor = .white
    
    init() {
        
        super.init(withTileSize: tileTexture.size())
        setupTiles()
        setupKick()
        
        self.color = PaddleNode.colors[PaddleNode.colorIndex]
        PaddleNode.colorIndex += 1
        self.tiles.forEach { $0.color = self.color }
    }
    
    private func setupKick() {
        
        self.kick = KickNode(withRadius:1.5 * self.tileTexture.size().width)
        self.kick.zRotation = CGFloat(M_PI_2)
        self.kick.position = CGPoint(x:1.5 * self.tileTexture.size().width, y: self.tileTexture.size().height)
        self.kick.paddle = self
        self.addChild(self.kick)
    }
    
    private func setupTiles() {
        
        for i in 0..<3 {
            let node = SKSpriteNode(texture: tileTexture)
            node.colorBlendFactor = 1.0
            /*let physicBody = SKPhysicsBody(rectangleOf: tileTexture.size())
            node.physicsBody = physicBody
            node.physicsBody?.categoryBitMask = CategoryBitmasks.corner.rawValue
            node.physicsBody?.collisionBitMask = CategoryBitmasks.ball.rawValue
            node.physicsBody?.contactTestBitMask = CategoryBitmasks.ball.rawValue
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.isDynamic = false*/
            addChild(node, atPosition: CGPoint(x: i, y: 0))
            self.tiles.append(node)
        }
        
        let textureSize = self.tileTexture.size()
        let size = CGSize(width: textureSize.width*3, height: textureSize.height)
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: size.width/2, y: size.height/2))
        self.physicsBody?.isDynamic = false
    }
    
    func performKick(){
        if self.canKick {
            self.canKick = false
            kick.isHidden = false
            
            let kickAction = SKAction.run {
                self.kick.enabled = true
                self.kick.animateKick(withSize: self.tiles.count-1)
            }
            
            let delayAction = SKAction.wait(forDuration: 0.250)
            
            let canKick = SKAction.run {
                self.kick.enabled = false
                self.canKick = true
            }

            
            kick!.run(
                SKAction.sequence([kickAction, delayAction, canKick]))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaddleNode: Updatable {
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        if (self.moveLeft) {
            let dx =  -(CGFloat)(deltaTime)*speed*400
            self.position = self.position.offset(dx: dx*cos(self.zRotation), dy: dx*sin(self.zRotation))
        }
        else if(self.moveRight) {
            let dx =  (CGFloat)(deltaTime)*speed*400
            self.position = self.position.offset(dx: dx*cos(self.zRotation), dy: dx*sin(self.zRotation))
        }
    }
}

extension PaddleNode: ControllerDelegate {
    
    func controller(_ controller: Controller, didSendCommand command: ControllerCommand) {
        
        switch(command) {
        case .leftDown:
            self.moveLeft = true
        case .rightDown:
            self.moveRight = true
        case .leftUp:
            self.moveLeft = false
        case .rightUp:
            self.moveRight = false
        case .kick:
            self.performKick()
            break
        }
    }
}
