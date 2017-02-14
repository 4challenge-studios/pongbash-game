//
//  GameArea.swift
//  pongball
//
//  Created by Vitor Muniz on 13/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//


import Foundation
import SpriteKit

class GameAreaNode : SKNode {
    
    var goal0:GoalNode?
    var goal1:GoalNode?
    var goal2:GoalNode?
    var goal3:GoalNode?
    
    var size: CGSize {
        didSet {
            setupGame()
        }
    }
    
    init(withSize size: CGSize) {
        self.size = size
        super.init()
        setupGame()
    }
    
    private func setupGame() {
        let rect0 = CGRect(x:-size.width/2 - size.width/16 , y: -size.height/2, width: size.width/16, height: size.height)
        let rect1 = CGRect(x: -size.width/2, y: size.height/2  + size.height/16, width: size.width, height: size.width)
        let rect2 = CGRect(x: size.width/2, y: -size.height/2, width: size.width/16, height: size.height)
        let rect3 = CGRect(x: -size.width/2, y: -size.height/2  - size.height/16, width: size.width, height: size.width/16)
        goal0 = GoalNode(rect: rect0, owner: "purple")
        goal1 = GoalNode(rect: rect1, owner: "orange")
        goal2 = GoalNode(rect: rect2, owner: "blue")
        goal3 = GoalNode(rect: rect3, owner: "red")
        let corner0 = CornerNode()
        let corner1 = CornerNode()
        let corner2 = CornerNode()
        let corner3 = CornerNode()
        addChild(corner0)
        addChild(corner1)
        addChild(corner2)
        addChild(corner3)
        
        corner0.position = CGPoint(x: -self.size.width/2, y: -self.size.height/2)//CGPoint(x: , y: 100)
        corner1.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        corner1.zRotation = CGFloat(M_PI_2)
        corner2.position = CGPoint(x: -self.size.width/2, y: self.size.height/2)
        corner2.zRotation = -CGFloat(M_PI_2)
        corner3.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        corner3.zRotation = CGFloat(M_PI)
        
        
        
        
        
        addChild(goal0!)
        addChild(goal1!)
        addChild(goal2!)
        addChild(goal3!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

