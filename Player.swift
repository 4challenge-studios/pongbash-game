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
    
    let style: Style
    
    init(withController controller:Controller? = nil, withStyle style: Style = .white) {
        self.controller = controller
        self.name = controller?.displayName ?? "Bot"
        self.style = style
    }
}
