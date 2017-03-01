//
//  Ball.swift
//  pongball
//
//  Created by Vitor Muniz on 10/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit


class BallNode : SKNode, Updatable {
    //TO DO: TROCAR TODOS OS SPRITES DESSA CLASSE PARA SER DINAMICO
    weak var owner: Player?
//<<<<<<< HEAD
    
    var sprite: SKSpriteNode?
   
/*=======
    let numberAnimationSprite = 4
    var texture:SKTexture! = SKTexture(image:UIImage(named:"white_1")!) {
        didSet {
            self.sprite.removeAllActions()
            self.sprite.removeFromParent()
            self.setupSprite()
            let vel =  self.physicsBody?.velocity
            self.physicsBody?.velocity = vel!/(vel?.length())!  * 400
        }
    }
    var sprite: SKSpriteNode!
    private var animation:SKAction!
>>>>>>> e42cd1bf3c1f15f9f73dfd5528db36e2e3f93a58*/
    var radius: CGFloat = 30.0 {
        
        didSet {
            setupSprite()
            setupPhysicsBody()
        }
    }
    
    var style: Style = .white {
        didSet {
            self.setupSprite()
        }
    }
    
    var textures: [SKTexture]
    
    func animateFast() {
        //self.sprite?.removeAction(forKey: "fast")
        
        let start = SKAction.animate(with: [textures[0], textures[1], textures[2], textures[3]],
                                     timePerFrame: 0.25, resize: true, restore: true)
        let end = SKAction.animate(with: [textures[2], textures[3]],
                                    timePerFrame: 0.25, resize: true, restore: true)
        let loop = SKAction.repeatForever(end)
        
        let action = SKAction.sequence([start,loop])

        self.sprite?.run(action, withKey: "fast")
    }
    
    func animateNormal() {
        self.sprite?.removeAction(forKey: "fast")
    }
    
    var isKicked:Bool = false {
        didSet {
            if isKicked {
               self.animateFast()
            } else {
                /*self.sprite.removeAllActions()
                self.sprite.removeFromParent()
                self.setupSprite()*/
                self.animateNormal()
                let vel =  self.physicsBody?.velocity
                self.physicsBody?.velocity = vel!/(vel?.length())!  * 400
            }
        }
    }
    
    override init() {

        self.textures = self.style.ballTextures

        super.init()
        
        setupSprite()
        setupPhysicsBody()
    }

    private func setupSprite() {
        self.sprite?.removeFromParent()
        
        let texture = self.style.ballTextures[0]
        self.sprite = SKSpriteNode(texture: texture)
        
        self.sprite!.colorBlendFactor = 0.0
        self.sprite!.size = CGSize(width: self.radius*2, height: self.radius*2)
        
        // add sprite as child
        self.addChild(self.sprite!)
    }
    
    internal func setupPhysicsBody() {
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 0 //reduce linear velocity
        //self.physicsBody?.angularDamping = 0 //reduce angular velocity
        self.physicsBody?.friction = 0
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = CategoryBitmasks.ball.rawValue
        self.physicsBody?.collisionBitMask = CategoryBitmasks.corner.rawValue | CategoryBitmasks.paddle.rawValue | CategoryBitmasks.goal.rawValue
        self.physicsBody?.contactTestBitMask = CategoryBitmasks.corner.rawValue | CategoryBitmasks.paddle.rawValue | CategoryBitmasks.goal.rawValue | CategoryBitmasks.ball.rawValue | CategoryBitmasks.kick.rawValue
    }
    
    /*internal func setupAnimation(){
        var texturesDidKick:[SKTexture] = []
        var texturesAfterKick:[SKTexture] = []
        for i in 0..<numberAnimationSprite {
            let texture = SKTexture(imageNamed: (self.owner?.color.rawValue)! + "\(i+1)")
            texturesDidKick.append(texture)
        }
        texturesAfterKick.append(texturesDidKick.last!)
        texturesAfterKick.append(texturesDidKick[texturesDidKick.count-2])
        let animationDidKick = SKAction.animate(with: texturesDidKick, timePerFrame: 0.25, resize: true, restore: true)
        let animationAfterKick = SKAction.animate(with: texturesAfterKick, timePerFrame: 0.25, resize: true, restore: true)
        let forever = SKAction.repeatForever(animationAfterKick)
        self.animation = SKAction.sequence([animationDidKick,forever])
    }*/
    
    func updateRotation() {

        let dx = self.physicsBody!.velocity.dx
        let dy = self.physicsBody!.velocity.dy
        let angle = atan2(dy, dx)
        
        let action = SKAction.rotate(toAngle: angle - CGFloat(M_PI_2), duration: 0)
        print(angle)
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        
        self.physicsBody!.allContactedBodies().forEach {
            
            if let kick = $0.node as? KickNode, kick.enabled {
                self.isKicked = true
            
                self.owner = kick.paddle!.owner
                self.style = kick.paddle!.style
                
                let kickPos = scene!.convert(kick.position, from: kick.parent!)
                let ballPos = scene!.convert(self.position, from: self.parent!)
                
                let dir = (ballPos - kickPos)
                let vel = CGVector(dx: dir.x, dy: dir.y)
                self.physicsBody?.velocity = vel/(vel.length())  * 800
                
                updateRotation()
            }
        }
    }
}

extension BallNode: ContactDelegate {

    func didBeginContact(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        let other = (nodeA as? BallNode) != nil ? nodeB : nodeA
        
        if let paddle = other as? PaddleNode {
            self.isKicked = false
            
            self.owner = paddle.owner
            self.style = paddle.style
            //self.texture = SKTexture(imageNamed:(self.owner?.color.rawValue)! + "1")
        }
        
        self.updateRotation()
    }
}
