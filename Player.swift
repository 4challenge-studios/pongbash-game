//
//  Player.swift
//  pongball
//
//  Created by Vitor Muniz on 16/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import UIKit


enum PlayerColor:String {
    case blue = "blue_"
    case red = "red_"
    case orange = "orange_"
    case green = "green_"
}

class Player {
    
    var score = 0
    var name = ""
    var controller: Controller?
    var color = PlayerColor.red
    static var colorIndex = 0
    static var colors: [PlayerColor] = [.red, .green, .blue, .orange]
    init(withController controller:Controller) {
        self.color = Player.colors[Player.colorIndex % 4]
        Player.colorIndex += 1
        self.controller = controller
        self.name = controller.displayName
    }
    init() {
        self.color = Player.colors[Player.colorIndex % 4]
        Player.colorIndex += 1
        self.name = "Bot"
    }
}
