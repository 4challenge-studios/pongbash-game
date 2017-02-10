//
//  Updatable.swift
//  pongball
//
//  Created by Matheus Martins on 2/10/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation

protocol Updatable {
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval)
}
