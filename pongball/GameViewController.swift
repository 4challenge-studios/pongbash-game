//
//  GameViewController.swift
//  pongball
//
//  Created by Matheus Martins on 2/2/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let multipeerManager: MultipeerManager = MultipeerManager()
    let controllerManager: ControllerManager = ControllerManager()
    
    var siriRemoteDelegate: SiriRemoteDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        multipeerManager.delegate = controllerManager

        presentMenuScene()
    }
    
    func presentMenuScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Menu") as? MenuScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.backgroundColor = UIColor(r: 20, g: 20, b: 20, alpha: 1)
                // Present the scene
                view.presentScene(scene)
                
                self.siriRemoteDelegate = scene
                scene.menuDelegate = self
            }
        }
    }
    
    func presentGameScene() {
        if let view = self.view as! SKView? {
            //let scene = ControllerTestScene(size: CGSize(width: 1024, height: 576))
            let scene = GameScene(size: CGSize(width: 1920, height: 1080))
            controllerManager.delegate = scene
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
             
            // Present the scene
            view.presentScene(scene)
             
            view.ignoresSiblingOrder = true
             
           // view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            if item.type == .select {
                self.siriRemoteDelegate?.didPress(button: .select)
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            if item.type == .playPause {
                self.siriRemoteDelegate?.didRelease(button: .select)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

extension GameViewController: MenuDelegate {
    func didPress(button: MenuButton) {
        
    }
    
    func didRelease(button: MenuButton) {
        self.siriRemoteDelegate = nil
        self.presentGameScene()
    }
}
