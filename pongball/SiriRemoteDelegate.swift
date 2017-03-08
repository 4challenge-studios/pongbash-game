//
//  SiriRemoteDelegate.swift
//  pongball
//
//  Created by Matheus Martins on 2/23/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation

enum SiriRemoteButton {
    case select
    case play
}

protocol SiriRemoteDelegate {
    func didPress(button: SiriRemoteButton)
    func didRelease(button: SiriRemoteButton)
}
