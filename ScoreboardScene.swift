//
//  ScoreBoardScene.swift
//  pongball
//
//  Created by Vitor Muniz on 04/03/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit
import GameController
class ScoreboardScene: SKScene {
    var players:[Player]?//ordenado por score
    var scoreboardElement:ScoreboardElement!
    var isDraw:Bool = false
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.scoreboardElement = ScoreboardElement(withNode: self.childNode(withName: "Player0")!)
        self.setupScoreboard()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func setupScoreboard(){
        var scoreElements = [ScoreboardElement]()
        scoreElements.append(ScoreboardElement(withNode: self.childNode(withName: "Player0")!))
        scoreElements.append(ScoreboardElement(withNode: self.childNode(withName: "Player1")!))
        scoreElements.append(ScoreboardElement(withNode: self.childNode(withName: "Player2")!))
        scoreElements.append(ScoreboardElement(withNode: self.childNode(withName: "Player3")!))
    
        self.players?.sort{
            $0.score > $1.score
        }
        var isDraw = false
        let playersWithSameScore = (players?.filter {
            $0.score == players?.first?.score
        })?.count
        if playersWithSameScore! >= 2 {
            isDraw = true
        }
        
        for i in 0..<scoreElements.count {
            scoreElements[i].playerName.text = players?[i].name
            scoreElements[i].score.text = players?[i].score.description
        }
        
        if isDraw {
            scoreElements.reversed().forEach {
                if $0.score.text != scoreElements.first?.score.text{
                    $0.crown.isHidden = true
                }
            }
        }
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
