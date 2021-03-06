//
//  Paddle.swift
//  pongball
//
//  Created by Matheus Martins on 2/3/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

enum PaddleLocation: Int {
    case bottom = 0
    case top = 1
    case left = 2
    case right = 3
}

class PaddleNode : TiledNode {
    
    weak var owner: Player?
    
    var sprite: SKSpriteNode!
    var tiles = [SKSpriteNode]()
    var kick: KickNode!
    
    var moveRight: Bool = false
    var moveLeft: Bool = false
    var canKick: Bool = true
    
    let location: PaddleLocation
    let style: Style
    
    var kickSound = SKAction.playSoundFileNamed("kick", waitForCompletion: false)
    
    init(withLocation location: PaddleLocation, andStyle style: Style) {
        
        self.location = location
        self.style = style
        
        super.init(withTileSize: self.style.tileTexture.size())
        setupTiles(numberOfTiles:3)
        setupKick(withRadius:1.5 * self.style.tileTexture.size().width)
    }
    
    func paddleSize() -> CGSize {
        
        let w = self.tiles.reduce(0) { return $0.0 + $0.1.size.width }
        let h = self.tiles.reduce(0) { return $0.0 + $0.1.size.height }
        
        return CGSize(width: w, height: h)
    }
    
    func canMoveLeft() -> Bool {
        let size = CGFloat(self.tiles.count) * self.tileSize.width
        switch(self.location) {
        case .bottom:
            return self.position.x > -358
        case .top:
            return self.position.x > -358 + size
        case .left:
            return self.position.y < 358
        case .right:
            return self.position.y > -358
        }
    }
    
    func canMoveRight() -> Bool {
        let size = CGFloat(self.tiles.count) * self.tileSize.width
        switch(self.location) {
        case .bottom:
            return self.position.x < 358 - size
        case .top:
            return self.position.x < 358
        case .left:
            return self.position.y > -358 + size
        case .right:
            return self.position.y < 358 - size
        }
    }
    
    func sendToLeft() {
        let size = CGFloat(self.tiles.count) * self.tileSize.width
        switch(self.location) {
        case .bottom:
            self.position.x = -358
        case .top:
            self.position.x = -358 + size
        case .left:
            self.position.y = 358
        case .right:
            self.position.y = -358
        }
    }
    
    func sendToRight() {
        let size = CGFloat(self.tiles.count) * self.tileSize.width
        switch(self.location) {
        case .bottom:
            self.position.x = 358 - size
        case .top:
            self.position.x = 358
        case .left:
            self.position.y = -358 + size
        case .right:
            self.position.y = 358 - size
        }
    }
    
    private func setupKick(withRadius radius:CGFloat) {
        if self.kick?.parent != nil {
            self.kick.removeFromParent()
        }
        self.kick = KickNode(withRadius:radius)
        self.kick.zRotation = CGFloat(M_PI_2)
        self.kick.position = CGPoint(x:radius, y: self.style.tileTexture.size().height)
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
            let node = SKSpriteNode(texture: self.style.tileTexture)
            addChild(node, atPosition: CGPoint(x: i, y: 0))
            self.tiles.append(node)
        }
    
        let textureSize = self.style.tileTexture.size()
        let size = CGSize(width: textureSize.width*CGFloat(number), height: textureSize.height)
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: size.width/2, y: size.height/2))
        self.physicsBody?.isDynamic = false
    }
    
    func performKick(){
        if self.canKick {
            self.canKick = false
            kick.isHidden = false
            
            self.kick.enabled = true
            self.kick.animateKick(withSize: self.tiles.count)
            
            Timer.after(0.250) {
                self.kick.enabled = false
                self.canKick = true
            }.start()
        }
    }
    
    
    func increaseSize() {
        if self.tiles.count < 4 {
        
            self.setupTiles(numberOfTiles:self.tiles.count+1)
            self.setupKick(withRadius:(CGFloat((Double(self.tiles.count)))) * self.style.tileTexture.size().width/2.0)
            self.tiles.last?.color = (self.tiles.first?.color)!
        }
        
    }
    
    func decreaseSize() {
        if self.tiles.count > 2 {
            self.setupTiles(numberOfTiles:self.tiles.count-1)
            self.setupKick(withRadius:(CGFloat((Double(self.tiles.count)))) * self.style.tileTexture.size().width/2)
            self.tiles.last?.color = (self.tiles.first?.color)!
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaddleNode: Updatable {
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        // intelijumencia artificial
        
        if self.owner?.controller == nil {
            let mod = fmod(currentTime, 4.0)
            
            if (1.9...2.1).contains(mod) { self.performKick() }
            
            if mod <= 2.0 {
                self.moveRight = true
                self.moveLeft = false
            } else {
                self.moveRight = false
                self.moveLeft = true
            }
        }
        
        // move paddle
        
        if self.moveLeft && self.canMoveLeft() {
            var dx =  -(CGFloat)(deltaTime)*speed*400
            if(self.location == .top) { dx = -dx }
            self.position = self.position.offset(dx: dx*cos(self.zRotation), dy: dx*sin(self.zRotation))
        }
        else if self.moveRight && self.canMoveRight() {
            var dx =  (CGFloat)(deltaTime)*speed*400
            if(self.location == .top) { dx = -dx }
            self.position = self.position.offset(dx: dx*cos(self.zRotation), dy: dx*sin(self.zRotation))
        }
        
        // send paddle back if out of bounds
        
        if !self.canMoveLeft() {
            sendToLeft()
        }
        
        if !self.canMoveRight() {
            sendToRight()
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
        default:
            break
        }
    }
}
