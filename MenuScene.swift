//
//  GameScene.swift
//  pongball
//
//  Created by Matheus Martins on 2/2/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit
import GameController

enum MenuButton {
    case play
}

protocol MenuDelegate: class {
    func didPress(button: MenuButton)
    func didRelease(button: MenuButton)
}

class MenuScene: SKScene {
    
    var playButton:SKSpriteNode?
    weak var menuDelegate: MenuDelegate?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.playButton = self.childNode(withName: "PlayButton") as! SKSpriteNode?
        self.playButton?.isUserInteractionEnabled = true
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    }
}

extension MenuScene: SiriRemoteDelegate {
    
    func didPress(button: SiriRemoteButton) {
        switch(button) {
        case .select:
            self.menuDelegate?.didRelease(button: .play)
        }
    }
    
    func didRelease(button: SiriRemoteButton) {
        switch(button) {
        case .select:
            self.menuDelegate?.didRelease(button: .play)
        }
    }
}
