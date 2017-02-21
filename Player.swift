//
//  Player.swift
//  pongball
//
//  Created by Vitor Muniz on 16/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import UIKit

class Player {
    
    var score = 0
    var name = ""
    var controller: Controller?
    var color = UIColor.red
    static var colorIndex = 0
    static var colors: [UIColor] = [.red, .green, .blue, .yellow]
    init(withController controller:Controller) {
        self.color = Player.colors[Player.colorIndex]
        Player.colorIndex += 1
        self.controller = controller
        self.name = controller.displayName
    }
    init() {
        self.color = Player.colors[Player.colorIndex]
        Player.colorIndex += 1
        self.name = "Bot"
    }
}
