//
//  Time.swift
//  pongball
//
//  Created by Vitor Muniz on 20/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

class GameTimerNode: SKNode {
    private var timeInterval:TimeInterval!
    private var timer:Timer!
    private var action:((Void)->Void)?
    var label:SKLabelNode!
    //classe do timerNode aqui para
    init(withTime timeInterval:TimeInterval,andFinishAction action:((Void)->Void)?) {
        super.init()
        self.timeInterval = timeInterval
        self.setupTimerLabel()
        self.setupTimer()
        //self.setupWatchAnimation()
        self.action = action
    }
    
    private func setupTimerLabel(){
        let timerStringLabel = SKLabelNode(text: "TIMER")
        timerStringLabel.fontSize = 80
        timerStringLabel.fontName = "silkscreen"
        self.addChild(timerStringLabel)
        timerStringLabel.position = CGPoint(x: 0, y:80)
        
        self.label = SKLabelNode(fontNamed: "silkscreen")
        let string = String(format: "%2.0f", self.timeInterval)
        self.label.text = string
        self.label.fontSize = 90
        self.label.position = CGPoint(x: 0, y: -40)
        addChild(self.label)
    }
    
    private func setupTimer(){
        self.timer = Timer.new(every:1.0.second) {
            self.updateTimerLabel()
            if self.timeInterval == 0 {
                self.stop()
                if let action = self.action {
                    //ativa acao planejada
                    action()
                }
            }
        }
    }
    
    private func updateTimerLabel(){
        self.timeInterval = self.timeInterval - 1.0
        let string = String(format: "%2.0f", self.timeInterval)
        self.label.text = string
    }
    /*
    private func setupWatchAnimation(){
        let watchScene = SKScene(fileNamed: "Watch")
        let watchNode = watchScene?.childNode(withName: "Watch") as! SKSpriteNode
        watchNode.removeFromParent()
        self.addChild(watchNode)
        watchNode.position = CGPoint(x: 170, y: 100)//numero mágico
    }
    */
    
    func start(){
        self.timer.start(modes: .defaultRunLoopMode)
    }
    
    func stop(){
        self.timer.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
