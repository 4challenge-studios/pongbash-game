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
import AVFoundation

class GameViewController: UIViewController {

    let multipeerManager: MultipeerManager = MultipeerManager()
    let controllerManager: ControllerManager = ControllerManager()
    
    var siriRemoteDelegate: SiriRemoteDelegate?
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        multipeerManager.delegate = controllerManager

        presentMenuScene()
    }
    
    func playMusic(named musicName: String) {
        let URL: URL = Bundle.main.url(forResource: musicName, withExtension: "mp3")!
        
        do {
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL)
            self.audioPlayer?.numberOfLoops = -1
            self.audioPlayer?.play()
            
        } catch {
            
        }
    }
    
    func presentMenuScene() {
        
        playMusic(named: "loop")
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Menu") as? MenuScene {
                // Set the scale mode to scale to fit the window
                controllerManager.delegate = scene
                scene.scaleMode = .aspectFill
                scene.backgroundColor = UIColor(r: 20, g: 20, b: 20, alpha: 1)
                // Present the scene
                view.presentScene(scene)
                
                self.siriRemoteDelegate = scene
                scene.menuDelegate = self
            }
        }
    }
    
    func presentGameScene(withPlayers players: [Player]) {
        
        playMusic(named: "music")
        
        if let view = self.view as! SKView? {
            
            
            //let scene = ControllerTestScene(size: CGSize(width: 1024, height: 576))
            let scene = GameScene(size: CGSize(width: 1920, height: 1080))
            scene.players = players
            
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
    func menuScene(menuScene: MenuScene, didPressButton button: MenuButton) {
        
    }
    
    func menuScene(menuScene: MenuScene, didReleaseButton button: MenuButton) {
        self.siriRemoteDelegate = nil
        self.presentGameScene(withPlayers: menuScene.players)
    }
}

extension GameViewController : GameDelegate {
    func gameSceneDidFinishGame(gameScene: GameScene) {
        
    }
}
