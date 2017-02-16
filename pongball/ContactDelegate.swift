//
//  File.swift
//  pongball
//
//  Created by Matheus Martins on 2/16/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

protocol ContactDelegate {
    func didBeginContact(_ contact: SKPhysicsContact)
    func didEndContact(_ contact: SKPhysicsContact)
}

extension ContactDelegate {
    func didBeginContact(_ contact: SKPhysicsContact) { }
    func didEndContact(_ contact: SKPhysicsContact) { }
}
