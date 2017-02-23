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
    let tileTexture = SKTexture(image: #imageLiteral(resourceName: "green_tile.png"))
    var canKick: Bool = true
    
    static var colorIndex = 0
    static var colors: [UIColor] = [.red, .green, .blue, .yellow]
    var color: UIColor = .white
    
    init() {
        self.color = PaddleNode.colors[PaddleNode.colorIndex]
        PaddleNode.colorIndex += 1
        super.init(withTileSize: tileTexture.size())
        setupTiles(numberOfTiles:3)
        setupKick(withRadius:1.5 * self.tileTexture.size().width)
    }
    
    func paddleSize() -> CGSize {
        let w = self.tiles.reduce(0) { return $0.0 + $0.1.size.width }
        let h = self.tiles.reduce(0) { return $0.0 + $0.1.size.height }
        
        return CGSize(width: w, height: h)
    }
    
    func canMoveLeft() -> Bool {
        
        var p = self.position.x
        
        if self.zRotation == CGFloat(M_PI_2) {
            p = self.position.y
        } else if self.zRotation == CGFloat(-M_PI_2) {
            p = -self.position.y
        } else if self.zRotation == CGFloat(M_PI) {
            p = -self.position.x
        }
        
        return p > -418
    }
    
    func canMoveRight() -> Bool {
        
        var p = self.position.y
        
        if self.zRotation == CGFloat(M_PI_2) {
            p = self.position.x
        } else if self.zRotation == CGFloat(-M_PI_2) {
            p = -self.position.x
        } else if self.zRotation == CGFloat(M_PI) {
            p = -self.position.y
        }
        
        return p < (418 - self.paddleSize().width)
    }
    
    private func setupKick(withRadius radius:CGFloat) {
        if self.kick?.parent != nil {
            self.kick.removeFromParent()
        }
        self.kick = KickNode(withRadius:radius)
        self.kick.zRotation = CGFloat(M_PI_2)
        self.kick.position = CGPoint(x:radius, y: self.tileTexture.size().height)
        self.kick.paddle = self
        self.addChild(self.kick)
    }
    
    private func setupTiles(numberOfTiles number:Int) {
        self.tiles.forEach {
            if $0.parent != nil {
                $0.removeFromParent()
            }
        }
        self.tiles.removeAll()
        
        for i in 0..<number {
            let node = SKSpriteNode(texture: tileTexture)
            node.colorBlendFactor = 1.0
            addChild(node, atPosition: CGPoint(x: i, y: 0))
            self.tiles.append(node)
        }
        
        
        
        let textureSize = self.tileTexture.size()
        let size = CGSize(width: textureSize.width*CGFloat(number), height: textureSize.height)
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: size.width/2, y: size.height/2))
        self.physicsBody?.isDynamic = false
        
        self.tiles.forEach { $0.color = self.color }
    }
    
    func performKick(){
        if self.canKick {
            self.canKick = false
            kick.isHidden = false
            
            let kickAction = SKAction.run {
                self.kick.enabled = true
                self.kick.animateKick(withSize: self.tiles.count)
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
    
    
    func increaseSize() {
        
        self.setupTiles(numberOfTiles:self.tiles.count+1)
        self.setupKick(withRadius:(CGFloat((Double(self.tiles.count)))) * self.tileTexture.size().width/2.0)
        self.tiles.last?.color = (self.tiles.first?.color)!
    }
    
    func decreaseSize() {
        
        self.setupTiles(numberOfTiles:self.tiles.count-1)
        self.setupKick(withRadius:(CGFloat((Double(self.tiles.count)))) * self.tileTexture.size().width/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaddleNode: Updatable {
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        if (self.moveLeft && self.canMoveLeft()) {
            let dx =  -(CGFloat)(deltaTime)*speed*400
            self.position = self.position.offset(dx: dx*cos(self.zRotation), dy: dx*sin(self.zRotation))
        }
        else if(self.moveRight && self.canMoveRight()) {
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
