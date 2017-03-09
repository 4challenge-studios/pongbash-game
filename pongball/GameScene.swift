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
import AVFoundation

protocol GameDelegate: class {
    func gameSceneDidFinishGame(gameScene: GameScene)
}

class GameScene: SKScene {
    
    var players: [Player] = []
    var gameArea: GameAreaNode!
    var scoreLabels: [ScoreNode]! = [ScoreNode]()
    var gameTimer:GameTimerNode!
    var startTime = 3
    weak var gameDelegate: GameDelegate?
    var startTimer:Timer!
    var prepareTimer:Timer!
    let audioPlayers: [String:AVAudioPlayer?] = [
        "hit" : GameScene.loadAudioPlayer(withSound: "hit")
    ]
    
    static func loadAudioPlayer(withSound sound: String) -> AVAudioPlayer? {
        let URL: URL = Bundle.main.url(forResource: sound, withExtension: "wav")!
        
        do {
            
            let ap = try AVAudioPlayer(contentsOf: URL)
            ap.prepareToPlay()
            
            return  ap
            
        } catch {
            
            return nil
        }
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(r: 38, g: 38, b: 38, alpha: 1.0)
        self.setupGameArea()
        
        for (k,v) in self.gameArea.paddles.enumerated() {
            v.owner = players[k]
            players[k].controller?.delegate = v
            players[k].name = "player\(k)"
        }
        
        for (k,v) in self.gameArea.goals.enumerated() {
            v.owner = players[k]
        }
        
        self.physicsWorld.contactDelegate = gameArea
        self.setupScores()
        self.setupGameTimer()
        self.setupBackground()
    }
    
    func setupBackground(){
        let texture = SKTexture(image: #imageLiteral(resourceName: "backgroundGame.png"))
        let sprite = SKSpriteNode(texture: texture)
        self.addChild(sprite)
        sprite.zPosition = -1
    }
    
    func setupGameTimer(){
        self.gameTimer = GameTimerNode(withTime:120) {
            self.finishGame()
        }
        self.addChild(self.gameTimer)
        self.gameTimer.position = CGPoint(x: -0.386*(((scene?.size.width)!)), y:0.4*((scene?.size.height)!-200))
        let label = SKLabelNode(text: "3")
        label.fontName = "silkscreen"
        label.fontSize = 200
        label.position = CGPoint(x:gameArea.position.x,y:gameArea.position.y-50)
        label.zPosition = 3
        self.addChild(label)
        var strings = ["BASH!","1","2","3"]
        self.startTimer = Timer.after(4.0.seconds) {
            //label com 3,2,1,BASH!
            label.removeFromParent()
            
            self.gameTimer.start()
            self.gameArea.setupBalls()
        }
        self.prepareTimer = Timer.every(1.0.seconds) {
            label.text = strings.popLast()
            if self.startTime == 0 {
                self.prepareTimer.invalidate()
            }
            self.startTime -= 1
        }
        prepareTimer.start()
        startTimer.start()
    }
    
    func setupGameArea() {
        let gameAreaSize = CGSize(width: view!.frame.height, height: view!.frame.height)
        self.gameArea = GameAreaNode(withSize: gameAreaSize)
        addChild(self.gameArea)
        self.gameArea.setup()
        self.gameArea.goals.forEach {$0.delegate = self}
    }
    
    func setupScores(){
        let label = SKLabelNode()
        label.fontName = "silkscreen"
        label.text = "Score"
        label.fontSize = 80
        let height = self.size.height
        let width = self.size.width
        for i in 0..<self.players.count {
            let scoreLabel = ScoreNode(withOwner:players[i])
            scoreLabel.position = CGPoint(x:width/3,y:(0.340 - CGFloat(i) * 0.1)*height)
            
            let texture = self.gameArea.paddles[i].style.tileTexture
            scoreLabel.tileTexture = texture
            scoreLabels.append(scoreLabel)
            addChild(scoreLabel)
        }
        addChild(label)
        label.position = CGPoint(x: 0.39*width, y: 0.4 * height)
    }
    
    func finishGame(){
        self.gameDelegate?.gameSceneDidFinishGame(gameScene: self)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        
        print(GCController.controllers())
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

extension GameScene {
    func playSound(_ soundName: String, completion: @escaping () -> Void) {
        if let ap_ = audioPlayers[soundName] {
            
            guard let ap = ap_ else { return }
            
            ap.play()
            
            Timer.after(ap.duration) {
                completion()
            }
        }
    }
}

extension GameScene: GoalDelegate {
    
    func goal(_ goal: GoalNode, didReceiveBall ball: BallNode) {
        
        goal.owner?.score += -25
        
        let isSame = (goal.owner === ball.owner)
        
        ball.owner?.score += isSame ? 0 : 100
        
        print("\(ball.owner?.name) fez gol em \(goal.owner?.name)")
        let sortedPlayers = players.sorted {$0.score > $1.score}

        scoreLabels.forEach { (score) in
            if let owner = score.owner {
                let string = String(format:"%02d",owner.score)
                score.label.text = string
                if score.owner.score == sortedPlayers.first?.score {
                    score.isWinning = true
                }else {
                    score.isWinning = false
                }
             }
        }
    }
}

extension GameScene: ControllerManagerDelegate, ControllerDelegate {
    
    func controllerManager(_ controllerManager: ControllerManager, controllerConnected controller: Controller) {
        for (i,p) in self.players.enumerated() {
            
            if let id = p.controller?.id, id == controller.id {
                p.name = controller.displayName
                p.controller = controller
                p.controller?.delegate = self.gameArea.paddles[i]
                p.controller?.sendCommand(p.style.rawValue)
                return
            }
        }
        
        for (i,p) in self.players.enumerated() {
            if p.controller == nil {
                p.name = controller.displayName
                p.controller = controller
                p.controller?.delegate = self.gameArea.paddles[i]
                p.controller?.sendCommand(p.style.rawValue)
                break
            }
        }
    }
    
    func controllerManager(_ controllerManager: ControllerManager, controllerDisconnected controller: Controller) {
        
        for (i,p) in self.players.enumerated() {
            if p.controller === controller {
                self.players[i].name = controller.displayName
                self.players[i].controller = nil
                break
            }
        }
        
        print("\(controller.displayName) desconectou!")
    }
    
    func controller(_ controller: Controller, didSendCommand command: ControllerCommand) {
        if command == .disconnect {
            
        }
    }
}

extension GameScene: SiriRemoteDelegate {
    
    func didPress(button: SiriRemoteButton) {
        switch(button) {
        //case .select:
            //self.menuDelegate?.menuScene(menuScene: self, didPressButton: .play)
        default:
            break
        }
    }
    
    func didRelease(button: SiriRemoteButton) {
        
    }
}
