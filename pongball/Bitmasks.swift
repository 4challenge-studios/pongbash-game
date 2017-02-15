//
//  Bitmasks.swift
//  pongball
//
//  Created by Vitor Muniz on 13/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import SpriteKit

enum CategoryBitmasks: UInt32 {
    case paddle   = 0b00000000
    case ball     = 0b00000001
    case corner   = 0b00000010
    case goal     = 0b00000100
    case kick     = 0b00010000
}

enum CollisionBitmasks: UInt32 {
    case none     = 0b00000000
}

enum ContactTestBitmasks: UInt32 {
    case ball     = 0b00000001
}

