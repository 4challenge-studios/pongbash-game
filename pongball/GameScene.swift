//
//  GameScene.swift
//  pongball
//
//  Created by Matheus Martins on 2/2/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var paddle: PaddleNode!
    private var balls:[BallNode]!
    override func didMove(to view: SKView) {
        
        self.paddle = PaddleNode()
        self.addChild(paddle)
        //spaw balls
        self.balls = [BallNode(),BallNode(),BallNode(),BallNode()]
        //impulse balls and add in scene
        let ballColors:[UIColor] = [.red,.blue,.orange,.purple]
        
        //end impulse
        //test border
        print(position)
        
        // ESSE MÉTODO FEZ O MUNDO BIÇAR COM AS BOLAS DO VITU
        let border = SKPhysicsBody(edgeLoopFrom: CGRect(x: -size.width/4, y: -size.height/2, width: size.width/2, height: size.height))
        border.friction = 0
        border.affectedByGravity = false
        
        // ESSA CATEGORY BIT MASK FAZ O CODIGO TESTAR SE QUICA COM OUTRA COISA. ESSA OUTRA COISA PRECISA TER UM COLLISIONBITMASK = 0B10 SE VC QUISER QUICAR
        border.categoryBitMask = 0b10
        border.isDynamic = false
        border.restitution = 1
        self.physicsBody = border
        //end test border
        GCController.startWirelessControllerDiscovery {
            print("wow \(GCController.controllers())")
        }
                
        
        // ESSE FOR TÁ MELHOR IN MY OPINION, MAS, FIKDIK
        for ball in balls {
            addChild(ball)
            ball.color = ballColors[Int(arc4random()%4)]
            ball.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random()%50), dy: -10))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.paddle.position = CGPoint(x: pos.x, y: -250.0)
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        
        print(GCController.controllers())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    private var previousTime: TimeInterval = 0.0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        var deltaTime = currentTime - previousTime
        if(previousTime == 0) { deltaTime = 0 }
        
        self.children.forEach {
            if let updatable = $0 as? Updatable {
                updatable.update(currentTime, deltaTime)
            }
        }
        
        previousTime = currentTime
    }
}
