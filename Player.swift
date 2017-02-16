//
//  Player.swift
//  pongball
//
//  Created by Vitor Muniz on 16/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
class Player {
    var score = 0
    var name = ""
    let controller:Controller!
    init(withController controller:Controller) {
        self.controller = controller
        self.name = controller.displayName
    }
    init() {
        self.controller = Controller()
        self.name = "Bot"
    }
}
