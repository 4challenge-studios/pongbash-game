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
    
    init(withController controller:Controller) {
        self.controller = controller
        self.name = controller.displayName
    }
    init() {
        self.name = "Bot"
    }
}
