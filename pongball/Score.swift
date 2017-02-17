//
//  Score.swift
//  pongball
//
//  Created by Vitor Muniz on 17/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit
class ScoreNode: SKLabelNode {
    var owner:Player!
    init(withOwner owner:Player) {
        super.init()
        self.owner = owner
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
